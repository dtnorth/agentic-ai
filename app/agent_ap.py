import os
from langchain_openai import ChatOpenAI
from langchain.agents import initialize_agent, Tool
from langchain.memory import ConversationBufferMemory
 
# Load and validate API key
openai_api_key = os.environ.get("OPENAI_API_KEY")
if not openai_api_key:
    raise ValueError("OPENAI_API_KEY must be set before running this script.")
 
# Initialize model
llm = ChatOpenAI(
    model="gpt-4",
    temperature=0,
    openai_api_key=openai_api_key
)
 
# Memory for context retention
memory = ConversationBufferMemory(memory_key="chat_history")
 
# Simple data retrieval tool
def fetch_data(query: str):
    # Simulated data retrieval
    return f"Data retrieved for query: {query}"
 
tools = [
    Tool(
        name="DataFetcher",
        func=fetch_data,
        description="Fetches business data for analysis."
    )
]
 
# Initialise agent
agent = initialize_agent(
    tools,
    llm,
    agent="chat-conversational-react-description",
    memory=memory
)
 
# REST API for interaction
from flask import Flask, request, jsonify
app = Flask(__name__)
 
@app.route("/ask", methods=["POST"])
def ask():
    user_input = request.json.get("query")
    response = agent.run(user_input)
    return jsonify({"response": response})
 
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
