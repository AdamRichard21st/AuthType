# [Amx Mod X] AuthType
Detects clients authid types based on dproto settings and displays through a list menu.

# Plugin description:
Once clients connect and get their authids authorized by engine, it reads if player authid type are:
* A Steam authid type
* A Non-Steam authid type
* A Non-Steam running SXE authid type
* HLTV authid type
* BOT authid type

Clients are able to check another clients' authid types by typing '/sxe' or '.sxe' on chat or 'amx_sxe' on console for a list menu or console list respectively.

# Commands:
* amx_say : Shows client's authid type on client/server console.
* say /sxe : Shows client's authid type on list menu.
* say .sxe : Shows client's authid type on list menu.

# How to use:
As a dproto based plugin, it'll need some settings to match with dproto.cfg settings. Those settings are:
* cid_NoSteam47   must to be 4
* cid_NoSteam48   must to be 4
* cid_Steam       must to be 1
* cid_SXEI        must to be 2 or 4
* IPGen_Prefix2   must to be 4

Running this plugin without those defined settings will list wrong clients' authid types.
