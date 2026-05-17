local fs = require "nixio.fs"

local m = Map("easytier", translate("EasyTier Web"))
m.description = translate("Configure the embedded EasyTier Web console. The service is managed by /etc/init.d/easytier.")

local s = m:section(TypedSection, "easytier", translate("Web Console Settings"))
s.addremove = false
s.anonymous = true

s:tab("general", translate("General"))
s:tab("listen", translate("Listen"))
s:tab("auth", translate("Authentication"))
s:tab("integration", translate("Integration"))

local enabled = s:taboption("general", Flag, "web_enabled", translate("Enable EasyTier Web"))
enabled.rmempty = false

local db_path = s:taboption("general", Value, "web_db_path", translate("Database Path"))
db_path.default = "/etc/easytier/et.db"
db_path.placeholder = "/etc/easytier/et.db"

local reset_db = s:taboption("general", Button, "_reset_web_db", translate("Reset Database"),
	translate("Delete the configured sqlite database, including -wal and -shm files. Restart EasyTier Web after resetting."))
reset_db.inputstyle = "remove"
reset_db.inputtitle = translate("Delete Database")
reset_db.write = function(self, section)
	local path = db_path:formvalue(section) or m.uci:get("easytier", section, "web_db_path") or "/etc/easytier/et.db"
	if path:match("^/") and path ~= "/" and not path:match("^/bin") and not path:match("^/sbin") and
		not path:match("^/usr/bin") and not path:match("^/usr/sbin") and not path:match("^/lib") and
		not path:match("^/boot") then
		fs.remove(path)
		fs.remove(path .. "-wal")
		fs.remove(path .. "-shm")
	end
end

local protocol = s:taboption("listen", ListValue, "web_protocol", translate("Server Protocol"))
protocol.default = "udp"
protocol:value("tcp", "tcp")
protocol:value("udp", "udp")
protocol:value("ws", "ws")
protocol:value("wss", "wss")

local web_port = s:taboption("listen", Value, "web_port", translate("Core Connection Port"))
web_port.datatype = "port"
web_port.default = "22020"
web_port.placeholder = "22020"

local fw_web = s:taboption("listen", Flag, "web_fw_web", translate("Allow WAN Access to Core Port"))
fw_web.rmempty = false

local api_port = s:taboption("listen", Value, "web_api_port", translate("API Port"))
api_port.datatype = "port"
api_port.default = "11211"
api_port.placeholder = "11211"

local api_addr = s:taboption("listen", Value, "web_api_addr", translate("API Listen Address"))
api_addr.datatype = "ipaddr"
api_addr.default = "0.0.0.0"
api_addr.placeholder = "0.0.0.0"

local html_port = s:taboption("listen", Value, "web_html_port", translate("Web UI Port"))
html_port.datatype = "port"
html_port.default = "11211"
html_port.placeholder = "11211"

local html_addr = s:taboption("listen", Value, "web_html_addr", translate("Web UI Listen Address"))
html_addr.datatype = "ipaddr"
html_addr.default = "0.0.0.0"
html_addr.placeholder = "0.0.0.0"

local fw_api = s:taboption("listen", Flag, "web_fw_api", translate("Allow WAN Access to API and Web UI"))
fw_api.rmempty = false

local api_host = s:taboption("listen", Value, "web_api_host", translate("Public API URL"))
api_host.placeholder = "http://192.168.1.1:11211"

local geoip_db = s:taboption("general", Value, "web_geoip_db", translate("GeoIP Database"))
geoip_db.placeholder = "/etc/easytier/GeoLite.mmdb"

local weblog = s:taboption("general", ListValue, "web_weblog", translate("Log Level"))
weblog.default = "off"
weblog:value("off", translate("Off"))
weblog:value("error", "error")
weblog:value("warn", "warn")
weblog:value("info", "info")
weblog:value("debug", "debug")
weblog:value("trace", "trace")

local disable_registration = s:taboption("auth", Flag, "web_disable_registration", translate("Disable Registration"))
disable_registration.rmempty = false

local allow_auto_create_user = s:taboption("auth", Flag, "web_allow_auto_create_user", translate("Auto Create Unknown Users"))
allow_auto_create_user.rmempty = false

local oidc_enabled = s:taboption("auth", Flag, "web_oidc_enabled", translate("Enable OIDC"))
oidc_enabled.rmempty = false

local oidc_issuer_url = s:taboption("auth", Value, "web_oidc_issuer_url", translate("OIDC Issuer URL"))
oidc_issuer_url.placeholder = "https://auth.example.com"
oidc_issuer_url:depends("web_oidc_enabled", "1")

local oidc_client_id = s:taboption("auth", Value, "web_oidc_client_id", translate("OIDC Client ID"))
oidc_client_id:depends("web_oidc_enabled", "1")

local oidc_client_secret = s:taboption("auth", Value, "web_oidc_client_secret", translate("OIDC Client Secret"))
oidc_client_secret.password = true
oidc_client_secret:depends("web_oidc_enabled", "1")

local oidc_redirect_url = s:taboption("auth", Value, "web_oidc_redirect_url", translate("OIDC Redirect URL"))
oidc_redirect_url:depends("web_oidc_enabled", "1")

local oidc_username_claim = s:taboption("auth", Value, "web_oidc_username_claim", translate("OIDC Username Claim"))
oidc_username_claim.default = "preferred_username"
oidc_username_claim.placeholder = "preferred_username"
oidc_username_claim:depends("web_oidc_enabled", "1")

local oidc_scopes = s:taboption("auth", Value, "web_oidc_scopes", translate("OIDC Scopes"))
oidc_scopes.default = "openid profile"
oidc_scopes.placeholder = "openid profile"
oidc_scopes:depends("web_oidc_enabled", "1")

local oidc_frontend_base_url = s:taboption("auth", Value, "web_oidc_frontend_base_url", translate("OIDC Frontend Base URL"))
oidc_frontend_base_url:depends("web_oidc_enabled", "1")

local oidc_disable_pkce = s:taboption("auth", Flag, "web_oidc_disable_pkce", translate("Disable OIDC PKCE"))
oidc_disable_pkce.rmempty = false
oidc_disable_pkce:depends("web_oidc_enabled", "1")

local webhook_enabled = s:taboption("integration", Flag, "web_webhook_enabled", translate("Enable Webhook"))
webhook_enabled.rmempty = false

local webhook_url = s:taboption("integration", Value, "web_webhook_url", translate("Webhook URL"))
webhook_url.placeholder = "https://webhook.example.com/easytier"
webhook_url:depends("web_webhook_enabled", "1")

local webhook_secret = s:taboption("integration", Value, "web_webhook_secret", translate("Webhook Secret"))
webhook_secret.password = true
webhook_secret:depends("web_webhook_enabled", "1")

local internal_auth_token = s:taboption("integration", Value, "web_internal_auth_token", translate("Internal Auth Token"))
internal_auth_token.password = true
internal_auth_token:depends("web_webhook_enabled", "1")

local web_instance_id = s:taboption("integration", Value, "web_web_instance_id", translate("Web Instance ID"))
web_instance_id.placeholder = "instance-1"
web_instance_id:depends("web_webhook_enabled", "1")

local web_instance_api_base_url = s:taboption("integration", Value, "web_web_instance_api_base_url", translate("Web Instance API Base URL"))
web_instance_api_base_url.placeholder = "http://192.168.1.1:11211"
web_instance_api_base_url:depends("web_webhook_enabled", "1")

return m
