"""
Async OpenAI client wrapper for generating candidate solutions.
Requires OPENAI_API_KEY environment variable.
"""
import os
import asyncio
from typing import Optional
import openai
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()


class OpenAIClient:
    """Async wrapper for OpenAI API with rate limiting."""
    
    def __init__(self, model: str = "gpt-4o", concurrency: int = 10, max_tokens: int = 4000):
        self.model = model
        self.max_tokens = max_tokens
        self._sem = asyncio.Semaphore(concurrency)
        
        # Get API key from environment
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("OPENAI_API_KEY environment variable not set")
        
        # Initialize async OpenAI client
        self.client = openai.AsyncOpenAI(api_key=api_key)
    
    async def generate(self, prompt: str, temperature: float = 0.7) -> str:
        """Generate a single response from OpenAI API."""
        async with self._sem:
            try:
                response = await self.client.chat.completions.create(
                    model=self.model,
                    messages=[
                        {"role": "system", "content": "You are an expert competitive programmer."},
                        {"role": "user", "content": prompt}
                    ],
                    temperature=temperature,
                    max_tokens=self.max_tokens
                )
                return response.choices[0].message.content.strip()
            except Exception as e:
                print(f"OpenAI API error: {e}")
                return ""
    
    async def generate_multiple(self, prompt: str, n: int, temperature: float = 0.7) -> list[str]:
        """Generate multiple responses concurrently."""
        tasks = [self.generate(prompt, temperature) for _ in range(n)]
        return await asyncio.gather(*tasks)
