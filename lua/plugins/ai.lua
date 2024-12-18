return {

	-- CopilotC-Nvim/CopilotChat.nvim

	{
		"CopilotC-Nvim/CopilotChat.nvim",

		show_help = "yes",
		highlight_headers = false,
		separator = "---",
		error_header = "> [!ERROR] Error",
		language = "Japanese",

		opts = function(_, options)
			local select = require("CopilotChat.select")
			local cached_gitdiff = nil

			options.prompts = {
				-- /Explain
				Explain = {
					prompt = "> /COPILOT_EXPLAIN"
						.. "\n\n"
						.. "Please briefly explain the following points regarding the operations and purpose of the code:"
						.. "\n\n"
						.. "1. The main functionality performed by the code\n"
						.. "2. The purpose of the code (what the code aims to achieve)"
						.. "\n\n"
						.. "Then, please explain the following points clearly:"
						.. "\n\n"
						.. "1. The flow of the process (how the code works)\n"
						.. "2. The intention behind the code (why it works in this way)",
					description = "Used to understand what the specified code is doing.",
				},
				ExplainJa = {
					prompt = "> /COPILOT_EXPLAIN"
						.. "\n\n"
						.. "このコードが行う処理とその目的について、以下の点を簡潔に説明してください："
						.. "\n\n"
						.. "1. コードが実行する主要な処理内容\n"
						.. "2. コードの目的（何を達成するためのコードか）"
						.. "\n\n"
						.. "その後、次の点をわかりやすく説明してください："
						.. "\n\n"
						.. "1. 処理の流れ（どのように動作するか）\n"
						.. "2. コードの意図（なぜそのように動作するのか）"
						.. "\n\n",
					description = "指定したコードが何をしているのかを理解するために使用します。",
				},

				-- /Commit
				Commit = {
					prompt = "> #git:unstaged"
						.. "\n\n"
						.. "Please create a Github commit message that satisfies the following conditions: "
						.. "\n\n"
						.. "1. It should be based on the current changes.\n"
						.. "2. It should follow the Commitzen conventions.\n"
						.. "3. The title should be 50 characters or less.\n"
						.. "4. The message should be wrapped at 72 characters.\n"
						.. "5. The message should be written in English."
						.. "\n\n"
						.. "Wrap the entire generated message in a `gitcommit` language-specified code block, and at the end, provide specific details of the changes and their reasons.",
					description = "Used to create the appropriate commit message based on the current changes.",
				},
				CommitJa = {
					prompt = "> #git:unstaged"
						.. "\n\n"
						.. "以下の条件を満たすGithubのコミットメッセージを作成してください："
						.. "\n\n"
						.. "1. 現在の変更に基づいた内容にする事\n"
						.. "2. Commitzenの規則に従う事\n"
						.. "3. タイトルは50文字以下にする事\n"
						.. "4. メッセージは72文字で改行する事\n"
						.. "5. メッセージは日本語で生成する事"
						.. "\n\n"
						.. "生成されたメッセージ全体を`gitcommit`言語指定のコードブロックで囲んで最後に具体的な変更点とその理由を教えてください。",
					description = "現在の変更内容に基づいて適切なコミットメッセージを作成するために使用します。",
					selection = function()
						if not cached_gitdiff then
							cached_gitdiff = select.gitdiff()
						end
						return cached_gitdiff
					end,
				},

				-- CommitStaged
				CommitStaged = {
					prompt = "> #git:staged"
						.. "\n\n"
						.. "Please create a Github commit message that satisfies the following conditions:"
						.. "\n\n"
						.. "1. It should be based on the current changes.\n"
						.. "2. It should follow Commitzen conventions.\n"
						.. "3. The title should be 50 characters or less.\n"
						.. "4. The message should be wrapped at 72 characters.\n"
						.. "5. The message should be written in English."
						.. "\n\n"
						.. "Wrap the entire generated message in a `gitcommit` language-specified code block, and at the end, provide specific details of the changes and their reasons.",
					description = "Used to create commit messages based on staged changes.",
					selection = function()
						if not cached_gitdiff then
							cached_gitdiff = select.gitdiff()
						end
						return cached_gitdiff
					end,
				},
				CommitStagedJa = {
					prompt = "> #git:staged"
						.. "\n\n"
						.. "以下の条件を満たすGithubのコミットメッセージを作成してください："
						.. "\n\n"
						.. "1. 現在の変更に基づいた内容にする事\n"
						.. "2. Commitzenの規則に従う事\n"
						.. "3. タイトルは50文字以下にする事\n"
						.. "4. メッセージは72文字で改行する事\n"
						.. "5. メッセージは日本語で生成する事"
						.. "\n\n"
						.. "最後にメッセージ全体を`gitcommit`言語指定のコードブロックで囲んだ後に具体的な変更点とその理由を教えてください。",
					description = "ステージされた変更を基にコミットメッセージを作成するために使用します。",
					selection = function()
						if not cached_gitdiff then
							cached_gitdiff = select.gitdiff()
						end
						return cached_gitdiff
					end,
				},
			}

			-- Define custom contexts
			options.contexts = {}

			-- Window layout settings
			options.window = {
				layout = "float",
				relative = "cursor",
				width = 1,
				height = 0.7,
				row = 1,
			}
		end,
	},
}
