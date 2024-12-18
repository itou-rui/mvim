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
				ReviewJa = {
					prompt = "> /COPILOT_REVIEW"
						.. "\n\n"
						.. "コードの可読性、パフォーマンス、バグの有無についてレビューを行い、改善点を具体的に提案してください。以下の点を考慮してください："
						.. "\n\n"
						.. "1. **可読性**：\n"
						.. "  - コードの構造は理解しやすいか？冗長な部分や改善できる変数名、関数名がある場合は指摘してください。\n"
						.. "  - コメントが不足している場合や、説明が不十分な部分についても言及してください。\n"
						.. "  - コードがモジュール化されているか、再利用性が考慮されているかも見てください。"
						.. "\n\n"
						.. "2. **パフォーマンス**：\n"
						.. "  - 現在のコードにパフォーマンスの問題がないか、もし改善できる部分があれば具体的に指摘してください。\n"
						.. "  - 処理の最適化が可能な箇所（例えば、ループの最適化やデータ構造の変更など）について提案してください。"
						.. "\n\n"
						.. "3. **バグの有無**：\n"
						.. "  - コードにバグがある場合、その原因を説明し、どのように修正すればよいかを提案してください。\n"
						.. "  - バグの可能性がありそうな箇所についても言及してください。"
						.. "\n\n"
						.. "最後に、どの部分を改善すればコードがさらに良くなるか、具体的な改善案とその理由を教えてください。",
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
				FixJa = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "コード内で発生しているバグや問題を特定し、修正案を具体的に提案してください。以下の点を考慮してください："
						.. "\n\n"
						.. "1. **バグの特定**：\n"
						.. "  - コード内で発生しているバグや問題を明確に説明してください。\n"
						.. "  - バグの原因を詳細に説明し、問題が発生している箇所を指摘してください。\n"
						.. "  - バグが発生する可能性のあるエッジケースやシナリオについても言及してください。\n"
						.. "\n\n"
						.. "2. **修正案の提案**：\n"
						.. "  - 特定した問題をどのように修正するか、具体的な修正方法を提案してください。\n"
						.. "  - 修正のために必要なコードの変更箇所や手順を明示してください。\n"
						.. "  - 提案した修正がどのように問題を解決するか、そしてコードがどのように改善されるかを説明してください。\n"
						.. "\n\n"
						.. "3. **テスト**：\n"
						.. "  - 修正後、どのようにテストすべきか提案してください。\n"
						.. "  - バグが解消されたことを確認するために、ユニットテストや統合テストの提案も行ってください。\n"
						.. "\n\n"
						.. "最後に、修正の影響とそのコードの安定性や機能性への改善点を説明してください。",
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
				OptimizeJa = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "コードのパフォーマンスや可読性を改善するための最適化案を提案してください。以下の点を考慮してください："
						.. "\n\n"
						.. "1. **パフォーマンスの最適化**：\n"
						.. "  - コード内のパフォーマンスボトルネックを特定してください（例：遅い関数、過剰なメモリ使用など）。\n"
						.. "  - アルゴリズムの改善やより効率的なデータ構造の使用など、最適化案を提案してください。\n"
						.. "\n\n"
						.. "2. **可読性の向上**：\n"
						.. "  - 理解しにくい部分や過度に複雑なコードを指摘してください。\n"
						.. "  - 変数名や関数名の改善、ネストの深いループの削減、ロジックの簡素化など、リファクタリング案を提案してください。\n"
						.. "\n\n"
						.. "3. **冗長性の削減**：\n"
						.. "  - 冗長なコードや重複する処理を特定してください。\n"
						.. "  - 効率や保守性を向上させるために、それらを削除または統合する方法を提案してください。\n"
						.. "\n\n"
						.. "最後に、これらの最適化がコードの全体的な品質にどのように改善をもたらすかを説明してください。",
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
				DocsJa = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "指定したコードに対する詳細なドキュメントを作成してください。\n"
						.. "関数やクラス、使い方、引数の説明などを含めてください。以下の点を考慮してください：\n\n"
						.. "1. **関数の説明**：\n"
						.. "  - 各関数が行う処理内容とその目的を明確に説明してください。\n"
						.. "  - 引数や返り値についても記述してください。\n"
						.. "\n\n"
						.. "2. **クラスの説明**：\n"
						.. "  - コードにクラスが含まれている場合、そのクラスの詳細な説明を行い、メソッドやプロパティも記載してください。\n"
						.. "  - クラスやメソッドの使用例も提供してください。\n"
						.. "\n\n"
						.. "3. **コードの使い方**：\n"
						.. "  - コードや関数の使用方法の例を示し、設定や依存関係についても説明してください。\n"
						.. "  - エッジケースやコードの動作に関する重要な注意点があれば記載してください。\n"
						.. "\n\n"
						.. "最後に、ドキュメントは明確で簡潔、かつ理解しやすい内容にしてください。",
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
				TestsJa = {
					prompt = "> /COPILOT_GENERATE"
						.. "\n\n"
						.. "指定したコードに対するテストコードを作成してください。\n"
						.. "どの部分をテストするかを考慮して、テストケースを設計してください。以下の点を考慮してください：\n\n"
						.. "1. **テストのカバレッジ**：\n"
						.. "  - テストが必要なコードの部分（エッジケースや関数、モジュールなど）を特定してください。\n"
						.. "  - 重要な処理の部分や機能を網羅するようにしてください。\n"
						.. "\n\n"
						.. "2. **テストの種類**：\n"
						.. "  - ユニットテスト、統合テスト、機能テストなど、どのタイプのテストを行うべきか提案してください。\n"
						.. "  - テストケースの具体的な例を挙げ、セットアップや依存関係も記述してください。\n"
						.. "\n\n"
						.. "3. **テストフレームワーク**：\n"
						.. "  - 使用するテストフレームワークや手法について提案してください。\n"
						.. "  - 提案したフレームワークを使ったテスト構造の例を提供してください。\n"
						.. "\n\n"
						.. "最後に、テストは明確で簡潔で、すべてのエッジケースと期待される動作をカバーするようにしてください。",
					description = "指定したコードに対するテストコードを作成するために使用します。",
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
