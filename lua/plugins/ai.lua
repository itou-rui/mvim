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

			options.prompts = {
				-- System prompts
				JapaneseAssistant = {
					system_prompt = base_system_prompt .. "\n\n" .. 'Responses should be in "Japanese".',
				},

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
				ExplainInJapanese = {
					prompt = "> /Explain" .. "\n" .. "> /JapaneseAssistant",
					description = "指定したコードが何をしているのかを理解するために使用します。",
				},

				-- /Review
				Review = {
					prompt = "> /COPILOT_REVIEW"
						.. "\n\n"
						.. "Review the readability, performance, and potential bugs in the code, and provide specific suggestions for improvement. Consider the following points:"
						.. "\n\n"
						.. "1. **Readability**:\n"
						.. "  - Is the structure of the code easy to understand? Point out any redundant parts or suggest improvements for variable and function names.\n"
						.. "  - If there are missing comments or parts where the explanation is insufficient, mention those as well.\n"
						.. "  - Consider whether the code is modularized and if reusability has been taken into account."
						.. "\n\n"
						.. "2. **Performance**:\n"
						.. "  - Are there any performance issues with the current code? If so, suggest specific parts that can be optimized.\n"
						.. "  - Provide suggestions for optimizing the code, such as loop optimization or changes to data structures.\n"
						.. "\n\n"
						.. "3. **Bugs**:\n"
						.. "  - If there are any bugs in the code, explain the causes and propose how to fix them.\n"
						.. "  - Mention any parts of the code that could potentially have bugs."
						.. "\n\n"
						.. "Finally, provide specific improvement suggestions and explain why these changes would make the code better.",
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
						.. "Identify the bugs or issues in the code and provide specific suggestions for fixing them. Consider the following points:\n\n"
						.. "1. **Bug Identification**:\n"
						.. "  - Clearly describe the bug or issue in the code.\n"
						.. "  - Explain the cause of the bug or problem in detail, highlighting any problematic areas in the code.\n"
						.. "  - Point out any edge cases or scenarios where the issue may occur.\n"
						.. "\n\n"
						.. "2. **Fix Proposal**:\n"
						.. "  - Suggest how to fix the identified issue. Be specific about the changes required in the code.\n"
						.. "  - Provide clear steps or code snippets for the fix.\n"
						.. "  - If applicable, explain why the proposed fix resolves the issue and how it improves the code.\n"
						.. "\n\n"
						.. "3. **Testing**:\n"
						.. "  - If possible, provide a suggestion for how to test the fix.\n"
						.. "  - Recommend any unit tests or integration tests that would ensure the bug is resolved.\n"
						.. "\n\n"
						.. "Finally, explain the overall impact of the fix and how it improves the stability or functionality of the code.",
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
						.. "Suggest specific optimizations to improve the performance and readability of the code. Consider the following points:\n\n"
						.. "1. **Performance Optimization**:\n"
						.. "  - Identify any performance bottlenecks in the code (e.g., slow functions, excessive memory usage, etc.).\n"
						.. "  - Suggest ways to optimize these areas, such as algorithm improvements or more efficient data structures.\n"
						.. "\n\n"
						.. "2. **Code Readability**:\n"
						.. "  - Point out any parts of the code that are difficult to understand or overly complex.\n"
						.. "  - Suggest refactoring opportunities, such as improving variable or function names, reducing nested loops, or simplifying logic.\n"
						.. "\n\n"
						.. "3. **Redundancy Removal**:\n"
						.. "  - Identify redundant code or operations that can be removed or combined.\n"
						.. "  - Suggest how to remove or optimize these parts to improve efficiency and maintainability.\n"
						.. "\n\n"
						.. "Finally, provide an explanation of how these optimizations would improve the overall quality of the code.",
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
						.. "Generate detailed documentation for the specified code. Please include descriptions for functions, classes, parameters, and usage examples.\n"
						.. "Consider the following points:\n\n"
						.. "1. **Function Descriptions**:\n"
						.. "  - Provide a clear explanation of each function's purpose and behavior.\n"
						.. "  - Include information on its input parameters and return values.\n"
						.. "\n\n"
						.. "2. **Class Descriptions**:\n"
						.. "  - If the code contains classes, provide a detailed description of each class, its methods, and properties.\n"
						.. "  - Include example usage for the class and its methods.\n"
						.. "\n\n"
						.. "3. **Code Usage**:\n"
						.. "  - Provide an example of how the code or function can be used, including any setup or dependencies.\n"
						.. "  - Include any edge cases or important notes about the code's behavior.\n"
						.. "\n\n"
						.. "Finally, ensure the documentation is clear, concise, and easy to follow.",
					description = "Used to generate detailed documentation for the provided code, including descriptions for functions, classes, arguments, and usage examples.",
				},
				DocsInJapanese = {
					prompt = "> /Docs" .. "\n" .. "> /JapaneseAssistant",
					description = "指定したコードに対する詳細なドキュメントを作成するために使用します。",
				},

				-- /Tests
				Tests = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "Create test cases for the specified code. Consider which parts of the code should be tested and design test cases accordingly. Please include the following points:\n\n"
						.. "1. **Test Coverage**:\n"
						.. "  - Identify which parts of the code need to be tested, such as edge cases, functions, or modules.\n"
						.. "  - Ensure full coverage of critical paths and functionality.\n"
						.. "\n\n"
						.. "2. **Test Types**:\n"
						.. "  - Suggest the types of tests to be written, such as unit tests, integration tests, or functional tests.\n"
						.. "  - Provide specific examples of test cases, including any setup or dependencies.\n"
						.. "\n\n"
						.. "3. **Testing Framework**:\n"
						.. "  - Recommend a testing framework or methodology, if applicable.\n"
						.. "  - Provide examples of how to structure the tests using the chosen framework.\n"
						.. "\n\n"
						.. "Finally, ensure the tests are clear, concise, and cover all edge cases and expected behaviors.",
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
					prompt = "> /COPILOT_EVALUATE"
						.. "\n\n"
						.. "Please evaluate the following points regarding the quality and performance of the code:"
						.. "\n\n"
						.. "1. The efficiency of the code (is it optimized for performance?)"
						.. "\n"
						.. "2. The readability and maintainability of the code (is the code easy to understand and modify?)"
						.. "\n"
						.. "3. The scalability of the code (can the code handle increased load or future changes?)"
						.. "\n\n"
						.. "Additionally, please provide any suggestions for improving the code or any potential issues you have identified."
						.. "\n\n"
						.. "Please provide a clear, concise evaluation of the code's strengths and weaknesses.",
					description = "Used to evaluate the quality, performance, and maintainability of the specified code, along with recommendations for improvement.",
				},
				EvaluationInJapanese = {
					prompt = "> /Evaluation" .. "\n" .. "> /JapaneseAssistant",
					description = "指定されたコードの品質、性能、保守性を評価し、改善勧告を行うために使用します。",
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
