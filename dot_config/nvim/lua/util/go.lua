local go_keys = function()
  local gprefix = "<localleader>g"
  --stylua: ignore
  return {
    { gprefix .. "ao", "<cmd>GoAlt<cr>",                           desc = "Open Alt" },
    { gprefix .. "aO", "<cmd>GoAlt!<cr>",                          desc = "Open Alt (create)" },
    { gprefix .. "as", "<cmd>GoAltS<cr>",                          desc = "Open Alt Split" },
    { gprefix .. "aS", "<cmd>GoAltS!<cr>",                         desc = "Open Alt Split (create)" },
    { gprefix .. "av", "<cmd>GoAltV<cr>",                          desc = "Open Alt Vsplit" },
    { gprefix .. "aV", "<cmd>GoAltV!<cr>",                         desc = "Open Alt Vsplit (create)" },
    -- debug
    { gprefix .. "ds", "<cmd>GoDebug<cr>",                         desc = "Start" },
    { gprefix .. "dS", "<cmd>GoDbgStop<cr>",                       desc = "Stop" },
    { gprefix .. "dc", "<cmd>GoDbgContinue<cr>",                   desc = "Continue" },
    { gprefix .. "dC", "<cmd>GoDebugConfig<cr>",                   desc = "Open launch.json (config)" },
    { gprefix .. "db", "<cmd>GoBreakToggle<cr>",                   desc = "Toggle Breakpoint" },
    { gprefix .. "dB", "<cmd>BreakCondition<cr>",                  desc = "Breapoint Condition" },
    { gprefix .. "dx", "<cmd>GoBreakSave<cr>",                     desc = "Save Breakpoints" },
    { gprefix .. "dX", "<cmd>GoBreakLoad<cr>",                     desc = "Load Breakpoints" },
    { gprefix .. "di", "<cmd>GoDbgKeys<cr>",                       desc = "Keymaps Info" },
    { gprefix .. "dI", "<cmd>GoDebug -h<cr>",                      desc = "Helps Info" },
    { gprefix .. "da", "<cmd>GoDebug -a<cr>",                      desc = "Attach to Remote" },
    { gprefix .. "dn", "<cmd>GoDebug -n<cr>",                      desc = "Nearest Function" },
    { gprefix .. "dr", "<cmd>GoDebug -R<cr>",                      desc = "Restart" },
    { gprefix .. "dt", "<cmd>GoDebug -t<cr>",                      desc = "Test File" },
    { gprefix .. "dp", "<cmd>GoDebug -p<cr>",                      desc = "Package Test" },
    { gprefix .. "dr", "<cmd>ReplRun<cr>",                         desc = "Run REPL" },
    { gprefix .. "dR", "<cmd>ReplToggle<cr>",                      desc = "Toggle REPL" },
    -- go mod
    { gprefix .. "mi", "<cmd>GoModInit<cr>",                       desc = "go mod init" },
    { gprefix .. "mt", "<cmd>GoModTidy<cr>",                       desc = "go mod tidy" },
    { gprefix .. "mv", "<cmd>GoModVendor<cr>",                     desc = "go mod vendor" },
    --test
    { gprefix .. "tc", "<cmd>GoCoverageToggle<cr>",                desc = "Toggle Coverage" },
    { gprefix .. "tC", "<cmd>GoCoverage -m<cr>",                   desc = "Show Metrics (coverage)" },
    { gprefix .. "tx", "<cmd>GoTestCompile<cr>",                   desc = "Compile" },
    { gprefix .. "tX", "<cmd>GoTermClose<cr>",                     desc = "Close Floating Terminal" },
    { gprefix .. "tf", "<cmd>GoTestFunc<cr>",                      desc = "Current Function" },
    { gprefix .. "tF", "<cmd>GoTestFile<cr>",                      desc = "Current File" },
    { gprefix .. "ts", "<cmd>GoTestFunc -s<cr>",                   desc = "Function Selection" },
    { gprefix .. "tp", "<cmd>GoTestPkg<cr>",                       desc = "Current Package/Folder" },
    -- tag
    { gprefix .. "Ta", "<cmd>GoAddTag<cr>",                        desc = "Add tag" },
    { gprefix .. "Tr", "<cmd>GoRmTag<cr>",                         desc = "Remove tag" },
    { gprefix .. "Tc", "<cmd>GoClearTag<cr>",                      desc = "Clear tag" },
    { gprefix .. "Tm", "<cmd>GoModifyTags<cr>",                    desc = "Modify tags" },

    { gprefix .. "l",  "<cmd>GoLint<cr>",                          desc = "Lint" },
    { gprefix .. "b",  "<cmd>GoBuild<cr>",                         desc = "Build" },
    { gprefix .. "f",  "<cmd>GoFmt<cr>",                           desc = "Format" },
    { gprefix .. "g",  "<cmd>GoGet<cr>",                           desc = "Get" },
    { gprefix .. "c",  "<cmd>GoCmt<cr>",                           desc = "Add Comment" },
    { gprefix .. "C",  function() require("go.comment").gen() end, desc = "Generate Comment" },
    { gprefix .. "s",  "<cmd>GoFillStruct<cr>",                    desc = "Fill Struct" },
    { gprefix .. "S",  "<cmd>GoFillSwitch<cr>",                    desc = "Fill Switch" },
    { gprefix .. "r",  "<cmd>GoRun<cr>",                           desc = "Run" },
    { gprefix .. "y",  "<cmd>GoImpl<cr>",                          desc = "Impl" },
    { gprefix .. "Y",  "<cmd>GoInstall<cr>",                       desc = "Install" },
    { gprefix .. "i",  "<cmd>GoIfErr<cr>",                         desc = "Add If Err" },
    { gprefix .. "I",  "<cmd>GoImports<cr>",                       desc = "Imports" },
    { gprefix .. "p",  "<cmd>GoFixPlurals<cr>",                    desc = "Fix Plurals" },
    -- packages
    { "<leader>pgf",   "<cmd>GoPkgOutline -f<cr>",                 desc = "Show in floating win" },
    { "<leader>pgg",   "<cmd>GoPkgOutline<cr>",                    desc = "Show in side panel" },
    { "<leader>pgj",   "<cmd>GoPkgOutline -p json<cr>",            desc = "JSON" },
  }
end

return {
  go_keys = go_keys,
}
