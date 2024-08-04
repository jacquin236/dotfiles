local issue = "<leader>Gi"
local pr = "<leader>Gp"
local re = "<leader>Gr"
local cmt = "<leader>Gc"
local thread = "<leader>Gt"
local label = "<leader>Gl"
local assignee = "<leader>Ga"
local rev = "<leader>Gv"
local merge = "<leader>Gm"
local octo = "<leader>go"

return {
  -- issues
  { issue .. "c", "<cmd>Octo issue close<cr>", desc = "Close issue" },
  { issue .. "C", "<cmd>Octo issue create<cr>", desc = "Create new issue" },
  { issue .. "e", "<cmd>Octo issue edit<cr>", desc = "Edit issue" },
  { issue .. "l", "<cmd>Octo issue list<cr>", desc = "List issue" },
  { issue .. "r", "<cmd>Octo issue reopen<cr>", desc = "Reopen issue" },
  { issue .. "R", "<cmd>Octo issue reload<cr>", desc = "Reload issue" },
  { issue .. "s", "<cmd>Octo issue search<cr>", desc = "Search issue" },
  { issue .. "u", "<cmd>Octo issue url<cr>", desc = "Copy issue url" },

  -- pull requests
  { pr .. "c", "<cmd>Octo pr close<cr>", desc = "Close PR" },
  { pr .. "C", "<cmd>Octo pr create<cr>", desc = "Create PR" },
  { pr .. "d", "<cmd>Octo pr diff<cr>", desc = "Show PR diff" },
  { pr .. "D", "<cmd>Octo pr changes<cr>", desc = "Show PR changes (Diff hunks)" },
  { pr .. "e", "<cmd>Octo pr edit<cr>", desc = "Edit PR" },
  { pr .. "o", "<cmd>Octo pr commits<cr>", desc = "List PR commits" },
  { pr .. "O", "<cmd>Octo pr checkout<cr>", desc = "Checkout PR" },
  { pr .. "l", "<cmd>Octo pr list<cr>", desc = "List PRs" },
  { pr .. "m", "<cmd>Octo pr ready<cr>", desc = "Mark PR draft as Ready for Review" },
  { pr .. "r", "<cmd>Octo pr reopen<cr>", desc = "Reopen PR" },
  { pr .. "R", "<cmd>Octo pr reload<cr>", desc = "Reload PR" },
  { pr .. "s", "<cmd>Octo pr search<cr>", desc = "Search PR" },
  { pr .. "S", "<cmd>Octo pr checks<cr>", desc = "Status of Checks run on PR" },
  { pr .. "u", "<cmd>Octo pr url<cr>", desc = "Copy PR url" },
  { pr .. "U", "<cmd>Octo pr browser<cr>", desc = "Open PR in browser" },

  -- merge PRs
  { merge .. "c", "<cmd>Octo pr merge commit<cr>", desc = "Merge commit" },
  { merge .. "s", "<cmd>Octo pr merge squash<cr>", desc = "Merge squash" },
  { merge .. "d", "<cmd>Octo pr merge delete<cr>", desc = "Merge delete" },
  { merge .. "r", "<cmd>Octo pr merge rebase<cr>", desc = "Merge rebase" },

  -- comments
  { cmt .. "a", "<cmd>Octo comment add<cr>", desc = "Add comment" },
  { cmt .. "d", "<cmd>Octo comment delete<cr>", desc = "Delete comment" },

  -- threads
  { thread .. "r", "<cmd>Octo thread resolve<cr>", desc = "Mark as Resolved" },
  { thread .. "u", "<cmd>Octo thread unresolve<cr>", desc = "Mark as Unresolved" },

  -- labels
  { label .. "a", "<cmd>Octo label add<cr>", desc = "Add label" },
  { label .. "r", "<cmd>Octo label remove<cr>", desc = "Remove label" },
  { label .. "c", "<cmd>Octo label create<cr>", desc = "Create label" },

  -- reaction
  { re .. "1", "<cmd>Octo reaction thumbs_up<cr>", desc = "👍" },
  { re .. "2", "<cmd>Octo reaction thumbs_down<cr>", desc = "👎" },
  { re .. "3", "<cmd>Octo reaction eyes<cr>", desc = "👀" },
  { re .. "4", "<cmd>Octo reaction laugh<cr>", desc = "😄" },
  { re .. "5", "<cmd>Octo reaction confused<cr>", desc = "😕" },
  { re .. "6", "<cmd>Octo reaction rocket<cr>", desc = "🚀" },
  { re .. "7", "<cmd>Octo reaction heart<cr>", desc = "❤️ " },
  { re .. "8", "<cmd>Octo reaction party<cr>", desc = "🎉" },

  -- assignee/reviewer
  { assignee .. "a", "<cmd>Octo assignee add<cr>", desc = "Assign user" },
  { assignee .. "u", "<cmd>Octo assignee remove<cr>", desc = "Unassign user" },
  { assignee .. "r", "<cmd>Octo reviewer add<cr>", desc = "Assign PR reviewer" },

  -- review
  { rev .. "c", "<cmd>Octo review close<cr>", desc = "Close window & Return to PR" },
  { rev .. "C", "<cmd>Octo review commit<cr>", desc = "Review a commit" },
  { rev .. "d", "<cmd>Octo review discard<cr>", desc = "Discard pending" },
  { rev .. "e", "<cmd>Octo review resume<cr>", desc = "Edit pending" },
  { rev .. "E", "<cmd>Octo review comments<cr>", desc = "Comment pending" },
  { rev .. "s", "<cmd>Octo review start<cr>", desc = "Start new review" },
  { rev .. "S", "<cmd>Octo review submit<cr>", desc = "Submit review" },

  { octo .. "i", "<cmd>Octo issue list<cr>", desc = "List Issues" },
  { octo .. "I", "<cmd>Octo issue search<cr>", desc = "Search Issues" },
  { octo .. "p", "<cmd>Octo pr list<cr>", desc = "List PRs" },
  { octo .. "P", "<cmd>Octo pr search<cr>", desc = "Search PRs" },
  { octo .. "r", "<cmd>Octo repo list<cr>", desc = "List Repos" },
  { octo .. "s", "<cmd>Octo search<cr>", desc = "Search" },
  { octo .. "l", "<cmd>Octo actions<cr>", desc = "List Actions" },

  { "<leader>a", "", desc = "+assignee (Octo)", ft = "octo" },
  { "<leader>c", "", desc = "+comment/code (Octo)", ft = "octo" },
  { "<leader>l", "", desc = "+label (Octo)", ft = "octo" },
  { "<leader>i", "", desc = "+issue (Octo)", ft = "octo" },
  { "<leader>r", "", desc = "+react (Octo)", ft = "octo" },
  { "<leader>p", "", desc = "+pr (Octo)", ft = "octo" },
  { "<leader>v", "", desc = "+review (Octo)", ft = "octo" },
  { "@", "@<C-x><C-o>", mode = "i", ft = "octo", silent = true },
  { "#", "#<C-x><C-o>", mode = "i", ft = "octo", silent = true },
}
