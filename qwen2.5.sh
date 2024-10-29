#!/bin/bash

# 設置 Claude API 密鑰、端點和版本
API_ENDPOINT="http://localhost:11434/api/chat"
#OLLAMA_MODEL="qwen2.5:7b"
OLLAMA_MODEL="qwen2.5:3b"

# 讀取 gitmessage 模板
if [ -f ~/.gitmessage ]; then
    TEMPLATE=$(cat ~/.gitmessage)
else
    TEMPLATE="{{CLAUDE_SUGGESTION}}"
fi

# 獲取暫存的更改
DIFF_OUTPUT=$(git diff --cached)

# 如果沒有暫存的更改，退出腳本
if [ -z "$DIFF_OUTPUT" ]; then
    echo "No staged changes found. Please stage your changes before running this script."
    exit 1
fi

# 定義生成 commit 消息的函數
generate_commit_message() {
#     local QUALITY_PROMPT="When analyzing the git diff and generating a commit message, please focus on the following aspects of code quality:
# 1. Clarity and readability of the changes
# 2. Adherence to coding standards and best practices
# 3. Potential performance improvements or optimizations
# 4. Security considerations, if applicable
# 5. Any refactoring or code structure improvements
# Please provide a concise yet informative commit message that reflects these quality aspects."
    local QUALITY_PROMPT="請在分析 git diff 並生成提交消息時，著重考慮代碼質量的以下方面：
1. 變更的清晰度和可讀性
2. 遵守編碼標準和最佳實踐
3. 可能的性能改進或優化
4. 安全考慮（如果適用）
5. 任何重構或代碼結構改進
請提供一條既簡潔又具信息量的提交消息，反映這些質量方面。"

    # 準備 API 請求，使用 jq 來正確轉義 JSON
    local REQUEST_BODY=$(jq -n \
        --arg template "$TEMPLATE" \
        --arg diff "$DIFF_OUTPUT" \
        --arg ollama_model "$OLLAMA_MODEL" \
        --arg quality_prompt "$QUALITY_PROMPT" \
        '{
            model: ($ollama_model),
            stream: false,
            messages: [
                {
                    role: "user",
                    content: "I have a git commit template and a git diff. Please use this template to generate a commit message:\n\n\($template)\n\nHere is the git diff:\n\n\($diff)\n\n\($quality_prompt)"
                }
            ]
        }')

    # 發送請求到 Claude API
    local RESPONSE=$(curl -s -X POST "$API_ENDPOINT" \
        -H "Content-Type: application/json" \
        -d "$REQUEST_BODY")

    # 從響應中提取 commit 消息
    echo "$RESPONSE" | jq .message.content -r
}

# 生成初始 commit 消息
COMMIT_MSG=$(generate_commit_message)

while true; do
    # 打印生成的 commit 消息
    echo "Generated commit message:"
    echo "------------------------"
    echo "$COMMIT_MSG"
    echo "------------------------"

    # 詢問用戶是否接受這個 commit 消息
    read -p "Do you want to use this commit message? (y/n/r - yes/no/regenerate): " choice

    case "$choice" in 
        y|Y ) 
            # 使用生成的 commit 消息創建 commit
            git commit -m "$COMMIT_MSG"
            echo "Commit created successfully."
            break
            ;;
        n|N ) 
            echo "Commit cancelled."
            exit 0
            ;;
        r|R ) 
            echo "Regenerating commit message..."
            COMMIT_MSG=$(generate_commit_message)
            ;;
        * ) 
            echo "Invalid choice. Please enter y, n, or r."
            ;;
    esac
done
