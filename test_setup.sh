#!/bin/bash
# Quick test script to verify the setup

echo "=== Stress Testing Pipeline - Quick Test ==="
echo ""

# Check Python
echo "1. Checking Python..."
python3 --version || { echo "❌ Python3 not found"; exit 1; }
echo "✓ Python3 found"
echo ""

# Check OPENAI_API_KEY
echo "2. Checking OPENAI_API_KEY..."
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ OPENAI_API_KEY not set"
    echo "   Run: export OPENAI_API_KEY='your-key-here'"
    exit 1
fi
echo "✓ OPENAI_API_KEY is set"
echo ""

# Check dependencies
echo "3. Checking dependencies..."
python3 -c "import openai" 2>/dev/null || { echo "⚠️  openai not installed. Run: pip install -r requirements.txt"; }
python3 -c "import aiohttp" 2>/dev/null || { echo "⚠️  aiohttp not installed. Run: pip install -r requirements.txt"; }
echo ""

# Check file structure
echo "4. Checking file structure..."
for file in run.py generate_candidates.py generate_stress_candidates.py executor.py llm_client.py; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "❌ $file missing"
    fi
done
echo ""

for file in prompts/candidate.prompt prompts/stress.prompt; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "❌ $file missing"
    fi
done
echo ""

if [ -f "examples/problem_example.json" ]; then
    echo "✓ examples/problem_example.json"
else
    echo "❌ examples/problem_example.json missing"
fi
echo ""

echo "=== Ready to run! ==="
echo ""
echo "Example command:"
echo "  python3 run.py --problem examples/problem_example.json --output ./test_output"
echo ""
