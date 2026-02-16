#!/usr/bin/env python
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

GOOGLE_API_KEY = os.environ.get('GOOGLE_API_KEY')

print("=" * 60)
print("TESTING GOOGLE GEMINI API KEY")
print("=" * 60)

# Check if API key exists
if not GOOGLE_API_KEY:
    print("❌ ERROR: GOOGLE_API_KEY not found in .env file")
    exit(1)

print(f"✓ API Key found: {GOOGLE_API_KEY[:20]}...")

# Test with google-generativeai directly
try:
    import google.generativeai as genai
    
    # Set the API key
    genai.configure(api_key=GOOGLE_API_KEY)
    
    print("✓ google.generativeai configured successfully")
    
    # List available models
    print("\nAvailable models:")
    for model in genai.list_models():
        if 'generateContent' in model.supported_generation_methods:
            print(f"  - {model.name}")
    
    # Test with gemini-2.0-flash
    print("\n" + "=" * 60)
    print("Testing with gemini-2.0-flash...")
    print("=" * 60)
    
    model = genai.GenerativeModel('gemini-2.0-flash')
    response = model.generate_content("What is AI in one sentence?")
    
    print("✓ API Test Successful!")
    print(f"Response: {response.text}")
    
except Exception as e:
    print(f"❌ ERROR: {type(e).__name__}: {str(e)}")
    exit(1)

print("\n" + "=" * 60)
print("API KEY IS VALID! ✓")
print("=" * 60)
