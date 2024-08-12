import openai
from flask import Flask, request, jsonify

# Set up your OpenAI API key
openai.api_key = "your-api-key"

app = Flask(__name__)

class Chatbot:
    def __init__(self, model="gpt-3.5-turbo", temperature=0.7, max_tokens=150):
        self.model = model
        self.temperature = temperature
        self.max_tokens = max_tokens
        self.conversation_history = []

    def ask_question(self, prompt):
        self.conversation_history.append({"role": "user", "content": prompt})
        response = openai.ChatCompletion.create(
            model=self.model,
            messages=self.conversation_history,
            temperature=self.temperature,
            max_tokens=self.max_tokens
        )
        answer = response['choices'][0]['message']['content'].strip()
        self.conversation_history.append({"role": "assistant", "content": answer})
        return answer

    def reset_conversation(self):
        self.conversation_history = []

chatbot = Chatbot(model="gpt-4", temperature=0.7, max_tokens=150)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    prompt = data.get("prompt", "")
    if not prompt:
        return jsonify({"error": "No prompt provided"}), 400

    response = chatbot.ask_question(prompt)
    return jsonify({"response": response})

@app.route('/reset', methods=['POST'])
def reset():
    chatbot.reset_conversation()
    return jsonify({"message": "Conversation history reset"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
