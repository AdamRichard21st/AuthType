#include < amxmodx >

/* SOURCE CONTRIBUITORS
*   Blaze9
*/

/* IMPORTANT NOTES
*   This plugin aims to detect and display the authid type
*   of connected clients based on dproto settings.
*
*   As a dproto based plugin, it'll need some settings to match with dproto.cfg settings.
*   Those settings are :
*       cid_NoSteam47   must to be 4
*       cid_NoSteam48   must to be 4
*       cid_Steam       must to be 1
*       cid_SXEI        must to be 2 or 4
*       IPGen_Prefix2   must to be 4 (or change 'IPGen_Prefix2' digit in source)
*/

/* Changelog:
    # 0.0.1
        released.
    # 0.0.2 -
        added concmd and extra clcmds,
        added HLTV and BOT AuthID types,
        critical fix and smalls improvements.
*/

/* Dproto.cfg
    # Make sure the digit of this variable matches the same digit of
    "IPGen_Prefix2" variable from dproto.cfg.
*/
#define IPGen_Prefix2 '4'

enum AuthID:
{
    	PENDING,
    	NO_SXE,
	STEAM,
	HLTV,
    	SXE,
    	BOT
}

enum
{
    _STATS,
    _COLOR
}

new const g_szAuthType[][][] =
{	/* [AuthID]     <[StatusName],  [Color={ d (grey), r (red), y (yellow), w (white) }]> */
	/* PENDING  */  { "PENDING",	"d" },
	/* NO_SXE   */  { "NO SXE",	"r" },
	/* STEAM    */  { "STEAM",	"y" },
	/* HLTV     */  { "HLTV",	"y" },
	/* SXE      */  { "SXE",	"y" },
	/* BOT      */  { "BOT",	"y" }
};

new const g_szMenuSayCommands[][] = 
{	
	"say /sxe",
	"say_team /sxe",
	"say .sxe",
	"say_team .sxe",
};

new AuthID:g_Client[ MAX_PLAYERS + 1 ];

public plugin_init()
{
    register_plugin( "Auth Type", "0.0.2", "AdamRichard21st" );
    register_concmd( "amx_sxe", "ConCommandAuthType", _, "Shows client's authid type" );

    for ( new i = 0; i < sizeof( g_szMenuSayCommands ); i++ )
    {
        register_clcmd( g_szMenuSayCommands[ i ], "SayCommandAuthType", _, "Shows client's authid type" );
    }
}

public client_connect( id )
{
    g_Client[ id ] = PENDING;
}

public client_authorized( id, const szAuth[] )
{
    switch ( szAuth[ 0 ] )
	{
		case 'V': g_Client[ id ] = szAuth[ 8 ] == IPGen_Prefix2 ? NO_SXE : SXE;
		case 'S': g_Client[ id ] = STEAM;
		case 'H': g_Client[ id ] = HLTV;
		case 'B': g_Client[ id ] = BOT;
		default : g_Client[ id ] = PENDING;
	}
}

public ConCommandAuthType( id )     return MenuClients( id, .bConsole=true );
public SayCommandAuthType( id )     return MenuClients( id, .bConsole=false );

MenuClients( id, bool:bConsole=false )
{
    new Player[ 32 ];
    new iNum;
    get_players( Player, iNum );

    if ( bConsole )
    {
        console_print( id, "[Authid Types] Client list:" );

        for ( new i = 0, szClient[ 64 ]; i < iNum; i++ )
        {
            get_user_name( Player[ i ], szClient, charsmax( szClient ) );
            console_print( id, "%d. %s [%s]", i + 1, szClient, g_szAuthType[ _:g_Client[ Player[ i ] ] ][ _STATS ] );
        }
    }
    else if ( id )
    {
        new iMenu = menu_create( "\w[\yAuthid Types\w] Client list:", "MenuHandle" );
        
        for ( new i = 0, iType, szClient[ 64 ]; i < iNum; i++ )
        {
            iType = _:g_Client[ Player[ i ] ];

            get_user_name( Player[ i ], szClient, charsmax( szClient ) );
            formatex( szClient, charsmax( szClient ), "%s \d(\%s%s\d)", szClient, g_szAuthType[ iType ][ _COLOR ], g_szAuthType[ iType ][ _STATS ] );

            menu_addtext2( iMenu, szClient );
        }
        menu_display( id, iMenu );
    }
    return PLUGIN_HANDLED;
}

public MenuHandle( id, iMenu, iItem )
{
    menu_destroy( iMenu );
}
