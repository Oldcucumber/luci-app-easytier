local http = luci.http

m = Map("easytier", translate("EasyTier Status"))
m.description = translate("A simple, secure, decentralized VPN solution for intranet penetration, implemented in Rust using the Tokio framework. "
        .. "Project URL: <a href=\"https://github.com/EasyTier/EasyTier\" target=\"_blank\">github.com/EasyTier/EasyTier</a>&nbsp;&nbsp;"
        .. "<a href=\"http://easytier.cn\" target=\"_blank\">Official Documentation</a>&nbsp;&nbsp;"
        .. "<a href=\"https://github.com/EasyTier/EasyTier/releases\" target=\"_blank\">EasyTier Releases</a>&nbsp;&nbsp;"
        .. "<a href=\"https://github.com/Oldcucumber/luci-app-easytier/releases\" target=\"_blank\">LuCI Releases</a>")
m.pageaction = false

-- 状态卡片
m:section(SimpleSection).template = "easytier/easytier_status"

-- 连接信息卡片
m:section(SimpleSection).template = "easytier/easytier_cli"

return m
