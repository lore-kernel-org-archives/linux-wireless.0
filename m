Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:33638 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753892Ab0KXB3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 20:29:03 -0500
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0133492139
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 10:29:00 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Colin Kincaid Williams <discord@uw.edu>
Subject: Re: ath5k driver AR5414 terrible performance in debian squeeze daily build
Date: Wed, 24 Nov 2010 10:29:01 +0900
Cc: linux-wireless@vger.kernel.org
References: <AANLkTi=sf1TpXbipHAygVGWDEXAamVegnULw0a+1yxYJ@mail.gmail.com>
In-Reply-To: <AANLkTi=sf1TpXbipHAygVGWDEXAamVegnULw0a+1yxYJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011241029.01826.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue November 23 2010 15:16:46 Colin Kincaid Williams wrote:
> ath5k Atheros AR5414 MAC:0xa5 PHY:0x61
> 
> When using the AR5414 I'm experiencing ping times from 10k ms to 50k
> ms on my desktop. When using my laptop with an iwl3945 card I'm
> getting ping times of 2-3ms. Furthermore, using the internet is almost
> impossible. I'm currently running debian squeeze with kernel version
> 2.6.32-5-amd64. When I was previously running ubuntu 10.10 with a 32
> bit kernel, specifically 2.6.32-24-generic, the performance was much
> better

Can you please try a more recent kernel, compat-wireless, a wireless-testing 
kernel or complain on Debian mailinglists instead?

Thanks,
bruno


> output from dmesg
> 
> [  159.114814] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  171.240617] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [  171.281053] wlan0: direct probe responded
> [  171.281059] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [  171.285451] wlan0: authenticated
> [  171.285476] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [  171.292464] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [  171.292467] wlan0: associated
> [  171.293177] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [  181.724017] wlan0: no IPv6 routers present
> [  204.316028] No probe response from AP 00:15:05:d3:ec:ba after
> 500ms, disconnecting.
> [  207.469758] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [  207.668024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [  207.868029] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [  208.068019] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [  220.538335] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [  220.736027] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [  220.936027] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [  221.136023] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [  233.570389] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [  233.768030] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [  233.968029] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [  234.168026] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [  246.619451] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [  246.816030] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [  247.016024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [  247.216023] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [  259.656252] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [  259.678675] wlan0: direct probe responded
> [  259.678680] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [  259.684534] wlan0: authenticated
> [  259.684556] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [  259.690585] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [  259.690587] wlan0: associated
> [ 1154.316028] No probe response from AP 00:15:05:d3:ec:ba after
> 500ms, disconnecting.
> [ 1157.465202] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1157.664024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 1157.864023] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 1158.064025] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 1170.491141] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1170.688029] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 1170.888028] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 1171.088023] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 1183.576728] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1183.776030] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 1183.976022] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 1184.176297] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 1196.642697] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1196.840024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 1197.040024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 1197.240024] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 1209.714746] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1209.912030] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 1210.112023] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 1210.312023] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 1222.759412] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1222.956018] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 1223.156023] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 1223.356023] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 1235.821764] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1236.020025] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 1236.220019] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 1236.270830] wlan0: direct probe responded
> [ 1236.270833] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 1236.468022] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 1236.668022] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 3)
> [ 1236.868023] wlan0: authentication with AP 00:15:05:d3:ec:ba timed out
> [ 1248.873014] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1249.015229] wlan0: direct probe responded
> [ 1249.015231] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 1249.053081] wlan0: authenticated
> [ 1249.053094] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 1249.175571] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [ 1249.175574] wlan0: associated
> [ 1651.316024] No probe response from AP 00:15:05:d3:ec:ba after
> 500ms, disconnecting.
> [ 1654.461066] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 1654.470820] wlan0: direct probe responded
> [ 1654.470823] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 1654.510738] wlan0: authenticated
> [ 1654.510751] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 1654.517096] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [ 1654.517099] wlan0: associated
> [ 1753.808073] ISO 9660 Extensions: Microsoft Joliet Level 3
> [ 1753.982829] ISO 9660 Extensions: RRIP_1991A
> [ 2055.316027] No probe response from AP 00:15:05:d3:ec:ba after
> 500ms, disconnecting.
> [ 2058.447221] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2058.644024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2058.844021] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 2059.044026] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 2071.477554] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2071.676026] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2071.876021] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 2071.990169] wlan0: direct probe responded
> [ 2071.990169] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2072.216025] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2072.416029] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 3)
> [ 2072.548790] wlan0: authenticated
> [ 2072.548810] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2072.560126] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [ 2072.560129] wlan0: associated
> [ 2292.316022] No probe response from AP 00:15:05:d3:ec:ba after
> 500ms, disconnecting.
> [ 2295.460468] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2295.660025] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2295.860028] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 2296.060027] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 2308.512669] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2308.712026] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2308.912023] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 2309.112024] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 2329.668567] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2329.801389] wlan0: direct probe responded
> [ 2329.801389] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2330.028029] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2330.228024] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 3)
> [ 2330.428027] wlan0: authentication with AP 00:15:05:d3:ec:ba timed out
> [ 2342.695967] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2342.778055] wlan0: direct probe responded
> [ 2342.778066] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2342.779523] wlan0: authenticated
> [ 2342.779550] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2342.783763] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [ 2342.783766] wlan0: associated
> [ 2773.316028] No probe response from AP 00:15:05:d3:ec:ba after
> 500ms, disconnecting.
> [ 2776.470057] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2776.668021] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2776.868023] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 2777.068022] wlan0: direct probe to AP 00:15:05:d3:ec:ba timed out
> [ 2789.513270] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2789.712025] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2789.912026] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 2790.112517] wlan0: direct probe responded
> [ 2790.112530] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2790.115902] wlan0: authenticated
> [ 2790.115930] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2790.121049] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [ 2790.121053] wlan0: associated
> [ 2794.113574] wlan0: deauthenticated from 00:15:05:d3:ec:ba (Reason: 1)
> [ 2797.274968] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2797.472025] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2797.580441] wlan0: direct probe responded
> [ 2797.580444] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2797.780025] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2797.980027] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 3)
> [ 2798.180023] wlan0: authentication with AP 00:15:05:d3:ec:ba timed out
> [ 2810.331618] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2810.508826] wlan0: direct probe responded
> [ 2810.508831] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2810.708026] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2810.741099] wlan0: authenticated
> [ 2810.741121] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2810.940026] wlan0: associate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2811.140021] wlan0: associate with AP 00:15:05:d3:ec:ba (try 3)
> [ 2811.340025] wlan0: association with AP 00:15:05:d3:ec:ba timed out
> [ 2823.373352] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2823.412497] wlan0: direct probe responded
> [ 2823.412500] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2823.612023] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2823.617359] wlan0: authenticated
> [ 2823.617371] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2823.816024] wlan0: associate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2824.016023] wlan0: associate with AP 00:15:05:d3:ec:ba (try 3)
> [ 2824.216019] wlan0: association with AP 00:15:05:d3:ec:ba timed out
> [ 2836.407342] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2836.604024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2836.804122] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 3)
> [ 2836.930517] wlan0: direct probe responded
> [ 2836.930520] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2837.128023] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2837.328029] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 3)
> [ 2837.528024] wlan0: authentication with AP 00:15:05:d3:ec:ba timed out
> [ 2849.446107] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2849.644024] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 2)
> [ 2849.793820] wlan0: direct probe responded
> [ 2849.793823] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2849.992029] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 2)
> [ 2850.192023] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 3)
> [ 2850.392030] wlan0: authentication with AP 00:15:05:d3:ec:ba timed out
> [ 2862.520064] wlan0: direct probe to AP 00:15:05:d3:ec:ba (try 1)
> [ 2862.543482] wlan0: direct probe responded
> [ 2862.543488] wlan0: authenticate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2862.545698] wlan0: authenticated
> [ 2862.545722] wlan0: associate with AP 00:15:05:d3:ec:ba (try 1)
> [ 2862.558726] wlan0: RX AssocResp from 00:15:05:d3:ec:ba (capab=0x71
> status=0 aid=3)
> [ 2862.558729] wlan0: associated
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> 
> output from wpa_supplicant
> 
> root@icecream:/home/discord# wpa_supplicant -Dwext -iwlan0
> -c/etc/wpa_supplicant.conf
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: Key negotiation completed with 00:15:05:d3:ec:ba [PTK=TKIP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:15:05:d3:ec:ba completed
> (auth) [id=0 id_str=]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: Key negotiation completed with 00:15:05:d3:ec:ba [PTK=TKIP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:15:05:d3:ec:ba completed
> (reauth) [id=0 id_str=]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: Key negotiation completed with 00:15:05:d3:ec:ba [PTK=TKIP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:15:05:d3:ec:ba completed
> (reauth) [id=0 id_str=]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: Key negotiation completed with 00:15:05:d3:ec:ba [PTK=TKIP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:15:05:d3:ec:ba completed
> (reauth) [id=0 id_str=]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: Key negotiation completed with 00:15:05:d3:ec:ba [PTK=TKIP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:15:05:d3:ec:ba completed
> (reauth) [id=0 id_str=]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: Key negotiation completed with 00:15:05:d3:ec:ba [PTK=TKIP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:15:05:d3:ec:ba completed
> (reauth) [id=0 id_str=]
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: 4-Way Handshake failed - pre-shared key may be incorrect
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Authentication with 00:15:05:d3:ec:ba timed out.
> Trying to associate with 00:15:05:d3:ec:ba (SSID='510_Williams' freq=2417
> MHz) Associated with 00:15:05:d3:ec:ba
> WPA: Key negotiation completed with 00:15:05:d3:ec:ba [PTK=TKIP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:15:05:d3:ec:ba completed
> (reauth) [id=0 id_str=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
