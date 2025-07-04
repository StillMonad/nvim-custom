
local is_showed = false

toggle_hidden_chars = function ()
    if is_showed == false then
        is_showed = true
        vim.opt.listchars = {
            tab="→ ",
            space="·",
            nbsp="␣",
            trail="•",
            eol="¶",
            precedes="«",
            extends="»",
        }
    else
        is_showed = false
        vim.opt.listchars = {}
    end
end

