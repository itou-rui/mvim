return {

	-- CopilotC-Nvim/CopilotChat.nvim

	{
		"CopilotC-Nvim/CopilotChat.nvim",

		show_help = "yes",
		highlight_headers = false,
		separator = "---",
		error_header = "> [!ERROR] Error",

		opts = function(_, options)
			local select = require("CopilotChat.select")
			local cached_gitdiff = nil

			local base_system_prompt = "You are an AI programming assistant."
				.. "\n\n"
				.. 'When asked for your name, you must respond with "GitHub Copilot".'
				.. "\n\n"
				.. "Follow the user's requirements carefully & to the letter."
				.. "\n\n"
				.. "Follow Microsoft content policies."
				.. "\n\n"
				.. "Avoid content that violates copyrights."
				.. "\n\n"
				.. 'If you are asked to generate content that is harmful, hateful, racist, sexist, lewd, violent, or completely irrelevant to software engineering, only respond with "Sorry, I can\'t assist with that."'
				.. "\n\n"
				.. "Keep your answers short and impersonal."
				.. "\n\n"
				.. "The user works in an IDE called Neovim which has a concept for editors with open files, integrated unit test support, an output pane that shows the output of running the code as well as an integrated terminal."
				.. "\n\n"
				.. "The user is working on a Darwin machine. Please respond with system specific commands if applicable."

			-- Uncomment out line numbers if you are concerned about them being included in the response by accident.
			-- options.model = "claude-3.5-sonnet"

			options.prompts = {
				-- System prompts
				JapaneseAssistant = {
					system_prompt = base_system_prompt .. "\n\n" .. "All responses should be in **Japanese**.",
				},

				-- /Explain
				Explain = {
					prompt = "> /COPILOT_EXPLAIN"
						.. "\n\n"
						.. "Write an explanation for the selected code as paragraphs of text.",
					description = "Used to understand what the specified code is doing.",
				},
				ExplainInJapanese = {
					prompt = "> /Explain" .. "\n" .. "> /JapaneseAssistant",
					description = "指定したコードが何をしているのかを理解するために使用します。",
				},

				-- /Review
				Review = {
					prompt = "> /COPILOT_REVIEW" .. "\n\n" .. "Review the selected code.",
					description = "Used to perform a review for a given code.",
				},
				ReviewInJapanese = {
					prompt = "> /Review" .. "\n" .. "> /JapaneseAssistant",
					description = "指定されたコードに対するレビューを行うために使用します。",
				},

				-- /Fix
				Fix = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "There is a problem in this code. Rewrite the code to show it with the bug fixed.",
					description = "It is used to fix problems (bugs and errors) occurring in the code.",
				},
				FixInJapanese = {
					prompt = "> /Fix" .. "\n" .. "> /JapaneseAssistant",
					description = "コード内で発生している問題（バグやエラー）を修正するために使用します。",
				},

				-- /Optimize
				Optimize = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "Optimize the selected code to improve performance and readability.",
					description = "It is used to propose optimizations for improving the performance and readability of the code.",
				},
				OptimizeInJapanese = {
					prompt = "> /Optimize" .. "\n" .. "> /JapaneseAssistant",
					description = "コードのパフォーマンスや可読性を向上させるための最適化案を提案するために使用します。",
				},

				-- /Docs
				Docs = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "Please add documentation comments to the selected code.",
					description = "Used to generate detailed documentation for the provided code, including descriptions for functions, classes, arguments, and usage examples.",
				},
				DocsInJapanese = {
					prompt = "> /Docs" .. "\n" .. "> /JapaneseAssistant",
					description = "指定したコードに対する詳細なドキュメントを作成するために使用します。",
				},

				-- /Tests
				Tests = {
					prompt = "> /COPILOT_GENERATE" .. "\n\n" .. "Please generate tests for my code.",
					description = "Used to create test cases for the provided code, covering critical paths, edge cases, and various test types.",
				},
				TestsInJapanese = {
					prompt = "> /Tests" .. "\n" .. "> /JapaneseAssistant",
					description = "指定したコードに対するテストコードを作成するために使用します。",
				},

				-- /FixDiagnostic
				FixDiagnostic = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "Based on the diagnostic results, fix the issues identified in the code. Provide specific details on the fixes made and explain the reasoning behind each change. Consider the following:\n\n"
						.. "1. **Problem Identification**:\n"
						.. "  - Review the diagnostic results and identify the problems or errors in the code.\n"
						.. "  - Explain the cause of the issues in detail, including any misconfigurations or logic errors.\n"
						.. "\n\n"
						.. "2. **Fix Implementation**:\n"
						.. "  - Suggest how to fix the identified problems, with clear steps or code snippets.\n"
						.. "  - Provide an explanation of why these fixes resolve the issues.\n"
						.. "\n\n"
						.. "3. **Testing and Validation**:\n"
						.. "  - Recommend steps for testing the fixes to ensure that the code works as expected.\n"
						.. "  - Provide any necessary tests or validation methods to confirm the resolution of the issue.\n"
						.. "\n\n"
						.. "Finally, explain the overall impact of these fixes on the stability and functionality of the code.",
					description = "Used to fix issues in the code based on diagnostic tool results, providing specific fixes and explanations.",
				},
				FixDiagnosticInJapanese = {
					prompt = "> /FixDiagnostic" .. "\n" .. "> /JapaneseAssistant",
					selection = select.diagnostics or {},
				},

				-- /Commit
				Commit = {
					prompt = "> #git:unstaged"
						.. "\n\n"
						.. "Write commit message for the change with commitizen convention."
						.. "Make sure the title has maximum 50 characters and message is wrapped at 72 characters.\n"
						.. "Wrap the whole message in code block with language gitcommit.\n",
					description = "Used to create the appropriate commit message based on the current changes.",
				},
				CommitInJapanese = {
					prompt = "> /Commit" .. "\n" .. "> /JapaneseAssistant",
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
						.. "Write commit message for the change with commitizen convention."
						.. "Make sure the title has maximum 50 characters and message is wrapped at 72 characters.\n"
						.. "Wrap the whole message in code block with language gitcommit.\n",
					description = "Used to create commit messages based on staged changes.",
					selection = function()
						if not cached_gitdiff then
							cached_gitdiff = select.gitdiff()
						end
						return cached_gitdiff
					end,
				},
				CommitStagedInJapanese = {
					prompt = "> /CommitStaged" .. "\n" .. "> /JapaneseAssistant",
					description = "ステージされた変更を基にコミットメッセージを作成するために使用します。",
					selection = function()
						if not cached_gitdiff then
							cached_gitdiff = select.gitdiff()
						end
						return cached_gitdiff
					end,
				},

				-- Evaluation
				Evaluation = {
					prompt = "> /COPILOT_GENERATE" .. "\n\n" .. "Evaluate the selected code.",
					description = "Used to evaluate the quality, performance, and maintainability of the specified code, along with recommendations for improvement.",
				},
				EvaluationInJapanese = {
					prompt = "> /Evaluation" .. "\n" .. "> /JapaneseAssistant",
					description = "指定されたコードの品質、性能、保守性を評価し、改善勧告を行うために使用します。",
				},
			}

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
