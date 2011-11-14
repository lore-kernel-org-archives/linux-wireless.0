Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:56292 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab1KNVsk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 16:48:40 -0500
Date: Mon, 14 Nov 2011 22:47:18 +0100
From: Lars Schotte <gusto@guttok.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn 3.0.9 aggreggation messages
Message-ID: <20111114224718.491c1777@hana.gusto> (sfid-20111114_224845_284999_D43391C9)
In-Reply-To: <1321305750.1796.11.camel@wwguy-ubuntu>
References: <20111114131642.31e8ddbd@hana.gusto>
	<1321283410.13578.33.camel@wwguy-ubuntu>
	<20111114201947.58d5fdf6@hana.gusto>
	<1321303101.1796.8.camel@wwguy-ubuntu>
	<20111114221847.2ca32e6a@hana.gusto>
	<1321305750.1796.11.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i am not sure any more if that kernel 3.0.8 is not affected as well,
because right now i booted into 3.0.8 but forgot to unset the debug
parameter and the message appeared. maybe it wasnt there before or i
just did not notice it, because it doesnt come so often on 3.0.8.

here a log of the 3.0.8 kernel (seems to be the same):
LY_ADD_STA
[  870.272144] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  870.272150] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  870.272158] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  870.272166] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  870.272173] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  870.272190] ieee80211 phy0: I iwlagn_mac_tx enter
[  870.272200] ieee80211 phy0: I iwlagn_mac_tx leave
[  870.567579] ieee80211 phy0: I iwlagn_mac_tx enter
[  870.567592] ieee80211 phy0: I iwlagn_mac_tx leave
[  870.567633] ieee80211 phy0: I iwlagn_mac_tx enter
[  870.567641] ieee80211 phy0: I iwlagn_mac_tx leave
[  870.567678] ieee80211 phy0: I iwlagn_mac_tx enter
[  870.567686] ieee80211 phy0: I iwlagn_mac_tx leave
[  870.569906] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0426, 92 bytes at 38[6]:4
[  870.569967] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  870.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0427, 12 bytes at 39[7]:4
[  870.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  871.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0428, 12 bytes at 40[8]:4
[  871.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  871.960219] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  871.960228] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  871.960235] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  871.960245] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0429, 96 bytes at 41[9]:4
[  871.960297] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  871.960314] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  871.960320] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  871.960327] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  871.960335] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  871.960342] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  871.960359] ieee80211 phy0: I iwlagn_mac_tx enter
[  871.960368] ieee80211 phy0: I iwlagn_mac_tx leave
[  872.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042A, 12 bytes at 42[10]:4
[  872.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  873.536102] ieee80211 phy0: I iwlagn_mac_tx enter
[  873.536117] ieee80211 phy0: I iwlagn_mac_tx leave
[  873.538417] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042B, 92 bytes at 43[11]:4
[  873.538478] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  874.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042C, 12 bytes at 44[12]:4
[  874.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  875.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042D, 12 bytes at 45[13]:4
[  875.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  876.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042E, 12 bytes at 46[14]:4
[  876.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  876.916232] ieee80211 phy0: I iwlagn_mac_tx enter
[  876.916245] ieee80211 phy0: I iwlagn_mac_tx leave
[  876.964389] ieee80211 phy0: I iwlagn_mac_tx enter
[  876.964400] ieee80211 phy0: I iwlagn_mac_tx leave
[  877.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042F, 12 bytes at 47[15]:4
[  877.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  879.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0430, 12 bytes at 48[16]:4
[  879.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  880.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0431, 12 bytes at 49[17]:4
[  880.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  881.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0432, 12 bytes at 50[18]:4
[  881.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  882.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0433, 12 bytes at 51[19]:4
[  882.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  883.584076] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  883.584086] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  883.584093] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  883.584103] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0434, 96 bytes at 52[20]:4
[  883.584158] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  883.584183] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  883.584189] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  883.584197] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  883.584205] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  883.584212] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  883.584231] ieee80211 phy0: I iwlagn_mac_tx enter
[  883.584240] ieee80211 phy0: I iwlagn_mac_tx leave
[  883.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0435, 12 bytes at 53[21]:4
[  883.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  884.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0436, 12 bytes at 54[22]:4
[  884.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  885.140502] ieee80211 phy0: I iwlagn_mac_tx enter
[  885.140514] ieee80211 phy0: I iwlagn_mac_tx leave
[  885.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0437, 12 bytes at 55[23]:4
[  885.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  886.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0438, 12 bytes at 56[24]:4
[  886.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  886.740222] ieee80211 phy0: I iwlagn_mac_tx enter
[  886.740232] ieee80211 phy0: I iwlagn_mac_tx leave
[  886.740287] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  886.740297] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  886.740304] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  886.740313] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0439, 96 bytes at 57[25]:4
[  886.740412] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  886.740441] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  886.740448] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  886.740455] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  886.740463] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  886.740470] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  886.740486] ieee80211 phy0: I iwlagn_mac_tx enter
[  886.740494] ieee80211 phy0: I iwlagn_mac_tx leave
[  887.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043A, 12 bytes at 58[26]:4
[  887.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  888.706057] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043B, 12 bytes at 59[27]:4
[  888.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  888.863546] ieee80211 phy0: I iwlagn_mac_tx enter
[  888.863559] ieee80211 phy0: I iwlagn_mac_tx leave
[  889.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043C, 12 bytes at 60[28]:4
[  889.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  890.125050] ieee80211 phy0: I iwlagn_mac_tx enter
[  890.125063] ieee80211 phy0: I iwlagn_mac_tx leave
[  891.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043D, 12 bytes at 61[29]:4
[  891.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  892.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043E, 12 bytes at 62[30]:4
[  892.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  893.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043F, 12 bytes at 63[31]:4
[  893.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  894.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0440, 12 bytes at 64[0]:4
[  894.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  895.264064] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  895.264074] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  895.264081] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  895.264091] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0441, 96 bytes at 65[1]:4
[  895.264149] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  895.264172] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  895.264179] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  895.264186] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  895.264194] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  895.264202] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  895.264219] ieee80211 phy0: I iwlagn_mac_tx enter
[  895.264228] ieee80211 phy0: I iwlagn_mac_tx leave
[  895.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0442, 12 bytes at 66[2]:4
[  895.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  896.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0443, 12 bytes at 67[3]:4
[  896.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  897.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0444, 12 bytes at 68[4]:4
[  897.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  898.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0445, 12 bytes at 69[5]:4
[  898.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  899.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0446, 12 bytes at 70[6]:4
[  899.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  900.569168] ieee80211 phy0: I iwlagn_mac_tx enter
[  900.569182] ieee80211 phy0: I iwlagn_mac_tx leave
[  900.569226] ieee80211 phy0: I iwlagn_mac_tx enter
[  900.569234] ieee80211 phy0: I iwlagn_mac_tx leave
[  900.569270] ieee80211 phy0: I iwlagn_mac_tx enter
[  900.569278] ieee80211 phy0: I iwlagn_mac_tx leave
[  900.571499] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0447, 92 bytes at 71[7]:4
[  900.571561] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  900.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0448, 12 bytes at 72[8]:4
[  900.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  901.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0449, 12 bytes at 73[9]:4
[  901.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  902.305714] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  902.305725] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  902.305731] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  902.305742] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x044A, 96 bytes at 74[10]:4
[  902.305794] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  902.305810] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  902.305817] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  902.305824] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  902.305832] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  902.305839] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  902.305858] ieee80211 phy0: I iwlagn_mac_tx enter
[  902.305868] ieee80211 phy0: I iwlagn_mac_tx leave
[  902.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044B, 12 bytes at 75[11]:4
[  902.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  903.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044C, 12 bytes at 76[12]:4
[  903.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  904.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044D, 12 bytes at 77[13]:4
[  904.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  905.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044E, 12 bytes at 78[14]:4
[  905.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  906.496093] ieee80211 phy0: I iwlagn_mac_tx enter
[  906.496107] ieee80211 phy0: I iwlagn_mac_tx leave
[  906.498406] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x044F, 92 bytes at 79[15]:4
[  906.498468] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  906.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0450, 12 bytes at 80[16]:4
[  906.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  907.313468] ieee80211 phy0: I iwlagn_mac_tx enter
[  907.313480] ieee80211 phy0: I iwlagn_mac_tx leave
[  909.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0451, 12 bytes at 81[17]:4
[  909.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  910.580448] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[  910.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0452, 12 bytes at 82[18]:4
[  910.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  911.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0453, 12 bytes at 83[19]:4
[  911.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  912.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0454, 12 bytes at 84[20]:4
[  912.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  913.376061] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  913.376071] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  913.376078] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  913.376088] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0455, 96 bytes at 85[21]:4
[  913.376144] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  913.376168] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  913.376175] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  913.376183] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  913.376191] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  913.376198] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  913.376229] ieee80211 phy0: I iwlagn_mac_tx enter
[  913.376239] ieee80211 phy0: I iwlagn_mac_tx leave
[  913.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0456, 12 bytes at 86[22]:4
[  913.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  914.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0457, 12 bytes at 87[23]:4
[  914.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  915.165197] ieee80211 phy0: I iwlagn_mac_tx enter
[  915.165210] ieee80211 phy0: I iwlagn_mac_tx leave
[  915.687222] ieee80211 phy0: I iwlagn_mac_tx enter
[  915.687232] ieee80211 phy0: I iwlagn_mac_tx leave
[  915.687287] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  915.687297] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  915.687304] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  915.687314] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0458, 96 bytes at 88[24]:4
[  915.687415] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  915.687449] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  915.687456] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  915.687463] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  915.687471] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  915.687478] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  915.687495] ieee80211 phy0: I iwlagn_mac_tx enter
[  915.687503] ieee80211 phy0: I iwlagn_mac_tx leave
[  915.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0459, 12 bytes at 89[25]:4
[  915.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  916.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045A, 12 bytes at 90[26]:4
[  916.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  917.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045B, 12 bytes at 91[27]:4
[  917.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  918.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045C, 12 bytes at 92[28]:4
[  918.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  918.866572] ieee80211 phy0: I iwlagn_mac_tx enter
[  918.866584] ieee80211 phy0: I iwlagn_mac_tx leave
[  919.515774] ieee80211 phy0: I iwlagn_mac_tx enter
[  919.515787] ieee80211 phy0: I iwlagn_mac_tx leave
[  919.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045D, 12 bytes at 93[29]:4
[  919.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  920.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045E, 12 bytes at 94[30]:4
[  920.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  921.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045F, 12 bytes at 95[31]:4
[  921.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  922.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0460, 12 bytes at 96[0]:4
[  922.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  923.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0461, 12 bytes at 97[1]:4
[  923.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  924.640077] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  924.640086] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  924.640093] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  924.640102] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0462, 96 bytes at 98[2]:4
[  924.640161] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  924.640185] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  924.640192] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  924.640199] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  924.640207] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  924.640214] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  924.640233] ieee80211 phy0: I iwlagn_mac_tx enter
[  924.640242] ieee80211 phy0: I iwlagn_mac_tx leave
[  924.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0463, 12 bytes at 99[3]:4
[  924.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  925.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0464, 12 bytes at 100[4]:4
[  925.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  926.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0465, 12 bytes at 101[5]:4
[  926.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  927.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0466, 12 bytes at 102[6]:4
[  927.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  928.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0467, 12 bytes at 103[7]:4
[  928.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  929.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0468, 12 bytes at 104[8]:4
[  929.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  930.579152] ieee80211 phy0: I iwlagn_mac_tx enter
[  930.579165] ieee80211 phy0: I iwlagn_mac_tx leave
[  930.579206] ieee80211 phy0: I iwlagn_mac_tx enter
[  930.579215] ieee80211 phy0: I iwlagn_mac_tx leave
[  930.579253] ieee80211 phy0: I iwlagn_mac_tx enter
[  930.579261] ieee80211 phy0: I iwlagn_mac_tx leave
[  930.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0469, 12 bytes at 105[9]:4
[  930.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  930.718048] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  930.718057] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  930.718063] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  930.718073] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x046A, 96 bytes at 106[10]:4
[  930.718123] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  930.718140] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  930.718146] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  930.718153] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  930.718162] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  930.718169] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  930.718183] ieee80211 phy0: I iwlagn_mac_tx enter
[  930.718191] ieee80211 phy0: I iwlagn_mac_tx leave
[  931.162712] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[  932.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046B, 12 bytes at 107[11]:4
[  932.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  933.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046C, 12 bytes at 108[12]:4
[  933.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  934.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046D, 12 bytes at 109[13]:4
[  934.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  935.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046E, 12 bytes at 110[14]:4
[  935.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  935.724115] ieee80211 phy0: I iwlagn_mac_tx enter
[  935.724126] ieee80211 phy0: I iwlagn_mac_tx leave
[  935.726693] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x046F, 92 bytes at 111[15]:4
[  935.726748] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  935.726787] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0
[  935.726796] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  935.726803] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  935.726810] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  935.726819] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0470, 96 bytes at 112[16]:4
[  935.726873] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  935.726889] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  935.726895] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  935.726902] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  935.726911] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  935.726918] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  935.726942] ieee80211 phy0: I iwlagn_mac_tx enter
[  935.726950] ieee80211 phy0: I iwlagn_mac_tx leave
[  935.727726] ieee80211 phy0: U iwlagn_tx_queue_set_status Activate BA Queue 10 on FIFO 1
[  935.727737] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0471, 92 bytes at 113[17]:4
[  935.727798] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  936.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0472, 12 bytes at 114[18]:4
[  936.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  936.925791] ieee80211 phy0: I iwlagn_mac_tx enter
[  936.925803] ieee80211 phy0: I iwlagn_mac_tx leave
[  938.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0473, 12 bytes at 115[19]:4
[  938.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  939.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0474, 12 bytes at 116[20]:4
[  939.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  940.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0475, 12 bytes at 117[21]:4
[  940.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  941.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0476, 12 bytes at 118[22]:4
[  941.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  942.062061] ieee80211 phy0: U iwlagn_tx_queue_set_status Deactivate AC/CMD Queue 10 on FIFO 1
[  942.368122] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  942.368131] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  942.368138] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  942.368148] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0477, 96 bytes at 119[23]:4
[  942.368202] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  942.368219] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  942.368226] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  942.368233] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  942.368241] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  942.368248] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  942.368266] ieee80211 phy0: I iwlagn_mac_tx enter
[  942.368276] ieee80211 phy0: I iwlagn_mac_tx leave
[  943.518090] ieee80211 phy0: I iwlagn_mac_tx enter
[  943.518102] ieee80211 phy0: I iwlagn_mac_tx leave
[  945.169526] ieee80211 phy0: I iwlagn_mac_tx enter
[  945.169542] ieee80211 phy0: I iwlagn_mac_tx leave
[  945.376582] ieee80211 phy0: I iwlagn_mac_tx enter
[  945.376592] ieee80211 phy0: I iwlagn_mac_tx leave
[  945.376652] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  945.376663] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  945.376669] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  945.376680] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0478, 96 bytes at 120[24]:4
[  945.376768] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  945.376794] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  945.376800] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  945.376808] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  945.376816] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  945.376823] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  945.376840] ieee80211 phy0: I iwlagn_mac_tx enter
[  945.376848] ieee80211 phy0: I iwlagn_mac_tx leave
[  948.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0479, 12 bytes at 121[25]:4
[  948.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  948.869489] ieee80211 phy0: I iwlagn_mac_tx enter
[  948.869501] ieee80211 phy0: I iwlagn_mac_tx leave
[  949.048195] ieee80211 phy0: I iwlagn_mac_tx enter
[  949.048208] ieee80211 phy0: I iwlagn_mac_tx leave
[  949.408057] ieee80211 phy0: I iwlagn_mac_tx enter
[  949.408067] ieee80211 phy0: I iwlagn_mac_tx leave
[  949.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047A, 12 bytes at 122[26]:4
[  949.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  950.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047B, 12 bytes at 123[27]:4
[  950.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  951.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047C, 12 bytes at 124[28]:4
[  951.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  952.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047D, 12 bytes at 125[29]:4
[  952.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  953.706057] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047E, 12 bytes at 126[30]:4
[  953.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  954.176076] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  954.176086] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  954.176093] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  954.176103] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x047F, 96 bytes at 127[31]:4
[  954.176159] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  954.176183] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  954.176190] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  954.176197] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  954.176205] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  954.176213] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  954.176231] ieee80211 phy0: I iwlagn_mac_tx enter
[  954.176240] ieee80211 phy0: I iwlagn_mac_tx leave
[  954.706055] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0480, 12 bytes at 128[0]:4
[  954.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  955.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0481, 12 bytes at 129[1]:4
[  955.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  956.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0482, 12 bytes at 130[2]:4
[  956.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  957.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0483, 12 bytes at 131[3]:4
[  957.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  958.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0484, 12 bytes at 132[4]:4
[  958.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  959.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0485, 12 bytes at 133[5]:4
[  959.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  960.602103] ieee80211 phy0: I iwlagn_mac_tx enter
[  960.602116] ieee80211 phy0: I iwlagn_mac_tx leave
[  960.602158] ieee80211 phy0: I iwlagn_mac_tx enter
[  960.602167] ieee80211 phy0: I iwlagn_mac_tx leave
[  960.602204] ieee80211 phy0: I iwlagn_mac_tx enter
[  960.602212] ieee80211 phy0: I iwlagn_mac_tx leave
[  960.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0486, 12 bytes at 134[6]:4
[  960.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  960.740240] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  960.740249] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  960.740255] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  960.740265] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0487, 96 bytes at 135[7]:4
[  960.740318] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  960.740334] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  960.740340] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  960.740347] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  960.740356] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  960.740363] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  960.740377] ieee80211 phy0: I iwlagn_mac_tx enter
[  960.740385] ieee80211 phy0: I iwlagn_mac_tx leave
[  962.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0488, 12 bytes at 136[8]:4
[  962.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  963.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0489, 12 bytes at 137[9]:4
[  963.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  964.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048A, 12 bytes at 138[10]:4
[  964.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  965.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048B, 12 bytes at 139[11]:4
[  965.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  965.743981] ieee80211 phy0: I iwlagn_mac_tx enter
[  965.743992] ieee80211 phy0: I iwlagn_mac_tx leave
[  965.746525] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x048C, 92 bytes at 140[12]:4
[  965.746586] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  966.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048D, 12 bytes at 141[13]:4
[  966.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  967.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048E, 12 bytes at 142[14]:4
[  967.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  968.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048F, 12 bytes at 143[15]:4
[  968.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  969.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0490, 12 bytes at 144[16]:4
[  969.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  970.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0491, 12 bytes at 145[17]:4
[  970.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  970.880060] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  970.880070] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  970.880077] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  970.880087] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0492, 96 bytes at 146[18]:4
[  970.880146] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  970.880170] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  970.880177] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  970.880185] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  970.880193] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  970.880200] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  970.880219] ieee80211 phy0: I iwlagn_mac_tx enter
[  970.880228] ieee80211 phy0: I iwlagn_mac_tx leave
[  971.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0493, 12 bytes at 147[19]:4
[  971.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  972.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0494, 12 bytes at 148[20]:4
[  972.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  973.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0495, 12 bytes at 149[21]:4
[  973.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  974.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0496, 12 bytes at 150[22]:4
[  974.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  975.169468] ieee80211 phy0: I iwlagn_mac_tx enter
[  975.169481] ieee80211 phy0: I iwlagn_mac_tx leave
[  975.376071] ieee80211 phy0: I iwlagn_mac_tx enter
[  975.376081] ieee80211 phy0: I iwlagn_mac_tx leave
[  975.376140] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  975.376150] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  975.376157] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  975.376167] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0497, 96 bytes at 151[23]:4
[  975.376255] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  975.376281] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  975.376288] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  975.376295] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  975.376304] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  975.376311] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  975.376326] ieee80211 phy0: I iwlagn_mac_tx enter
[  975.376335] ieee80211 phy0: I iwlagn_mac_tx leave
[  975.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0498, 12 bytes at 152[24]:4
[  975.706295] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  976.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0499, 12 bytes at 153[25]:4
[  976.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  976.761722] ieee80211 phy0: I iwlagn_mac_tx enter
[  976.761738] ieee80211 phy0: I iwlagn_mac_tx leave
[  976.762777] ieee80211 phy0: I iwlagn_mac_tx enter
[  976.762789] ieee80211 phy0: I iwlagn_mac_tx leave
[  976.998569] ieee80211 phy0: I iwlagn_mac_tx enter
[  976.998580] ieee80211 phy0: I iwlagn_mac_tx leave
[  976.999192] ieee80211 phy0: I iwlagn_mac_tx enter
[  976.999202] ieee80211 phy0: I iwlagn_mac_tx leave
[  977.250643] ieee80211 phy0: I iwlagn_mac_tx enter
[  977.250654] ieee80211 phy0: I iwlagn_mac_tx leave
[  977.256519] ieee80211 phy0: I iwlagn_mac_tx enter
[  977.256529] ieee80211 phy0: I iwlagn_mac_tx leave
[  977.256573] ieee80211 phy0: I iwlagn_mac_tx enter
[  977.256581] ieee80211 phy0: I iwlagn_mac_tx leave
[  977.259705] ieee80211 phy0: I iwlagn_mac_tx enter
[  977.259715] ieee80211 phy0: I iwlagn_mac_tx leave
[  977.262032] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x049A, 92 bytes at 154[26]:4
[  977.262085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  977.544528] ieee80211 phy0: I iwlagn_mac_tx enter
[  977.544538] ieee80211 phy0: I iwlagn_mac_tx leave
[  977.546831] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x049B, 92 bytes at 155[27]:4
[  977.546892] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  977.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049C, 12 bytes at 156[28]:4
[  977.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  977.798485] ieee80211 phy0: I iwlagn_mac_tx enter
[  977.798493] ieee80211 phy0: I iwlagn_mac_tx leave
[  978.873727] ieee80211 phy0: I iwlagn_mac_tx enter
[  978.873740] ieee80211 phy0: I iwlagn_mac_tx leave
[  979.042783] ieee80211 phy0: I iwlagn_mac_tx enter
[  979.042796] ieee80211 phy0: I iwlagn_mac_tx leave
[  980.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049D, 12 bytes at 157[29]:4
[  980.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  981.140070] ieee80211 phy0: I iwlagn_mac_tx enter
[  981.140083] ieee80211 phy0: I iwlagn_mac_tx leave
[  981.706030] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049E, 12 bytes at 158[30]:4
[  981.706068] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  982.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049F, 12 bytes at 159[31]:4
[  982.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  983.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A0, 12 bytes at 160[0]:4
[  983.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  984.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A1, 12 bytes at 161[1]:4
[  984.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  985.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A2, 12 bytes at 162[2]:4
[  985.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  986.240076] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  986.240087] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  986.240093] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  986.240103] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04A3, 96 bytes at 163[3]:4
[  986.240160] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  986.240184] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  986.240191] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  986.240199] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  986.240207] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  986.240214] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  986.240234] ieee80211 phy0: I iwlagn_mac_tx enter
[  986.240244] ieee80211 phy0: I iwlagn_mac_tx leave
[  986.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A4, 12 bytes at 164[4]:4
[  986.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  987.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A5, 12 bytes at 165[5]:4
[  987.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  988.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A6, 12 bytes at 166[6]:4
[  988.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  989.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A7, 12 bytes at 167[7]:4
[  989.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  990.610157] ieee80211 phy0: I iwlagn_mac_tx enter
[  990.610170] ieee80211 phy0: I iwlagn_mac_tx leave
[  990.610212] ieee80211 phy0: I iwlagn_mac_tx enter
[  990.610220] ieee80211 phy0: I iwlagn_mac_tx leave
[  990.610257] ieee80211 phy0: I iwlagn_mac_tx enter
[  990.610265] ieee80211 phy0: I iwlagn_mac_tx leave
[  990.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A8, 12 bytes at 168[8]:4
[  990.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  990.746648] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[  990.746656] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[  990.746663] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[  990.746672] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04A9, 96 bytes at 169[9]:4
[  990.746723] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[  990.746740] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[  990.746746] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[  990.746753] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[  990.746762] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[  990.746769] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[  990.746784] ieee80211 phy0: I iwlagn_mac_tx enter
[  990.746792] ieee80211 phy0: I iwlagn_mac_tx leave
[  991.101547] ieee80211 phy0: I iwlagn_mac_tx enter
[  991.101559] ieee80211 phy0: I iwlagn_mac_tx leave
[  991.103854] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04AA, 92 bytes at 170[10]:4
[  991.103926] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  991.141068] ieee80211 phy0: I iwlagn_mac_tx enter
[  991.141077] ieee80211 phy0: I iwlagn_mac_tx leave
[  991.143365] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04AB, 92 bytes at 171[11]:4
[  991.143427] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[  992.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AC, 12 bytes at 172[12]:4
[  992.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  993.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AD, 12 bytes at 173[13]:4
[  993.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  994.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AE, 12 bytes at 174[14]:4
[  994.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  995.662974] ieee80211 phy0: I iwlagn_mac_tx enter
[  995.662986] ieee80211 phy0: I iwlagn_mac_tx leave
[  995.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AF, 12 bytes at 175[15]:4
[  995.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[  995.753868] ieee80211 phy0: I iwlagn_mac_tx enter
[  995.753880] ieee80211 phy0: I iwlagn_mac_tx leave
[  996.939801] ieee80211 phy0: I iwlagn_mac_tx enter
[  996.939814] ieee80211 phy0: I iwlagn_mac_tx leave
[  997.847280] ieee80211 phy0: I iwlagn_mac_tx enter
[  997.847293] ieee80211 phy0: I iwlagn_mac_tx leave
[  998.012604] ieee80211 phy0: I iwlagn_mac_tx enter
[  998.012629] ieee80211 phy0: I iwlagn_mac_tx leave
[  998.333386] ieee80211 phy0: I iwlagn_mac_tx enter
[  998.333401] ieee80211 phy0: I iwlagn_mac_tx leave
[  999.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B0, 12 bytes at 176[16]:4
[  999.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1000.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B1, 12 bytes at 177[17]:4
[ 1000.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1001.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B2, 12 bytes at 178[18]:4
[ 1001.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1002.405268] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1002.405282] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1002.570516] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1002.570530] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1002.572848] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04B3, 92 bytes at 179[19]:4
[ 1002.572911] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1002.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B4, 12 bytes at 180[20]:4
[ 1002.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1003.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B5, 12 bytes at 181[21]:4
[ 1003.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1004.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B6, 12 bytes at 182[22]:4
[ 1004.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1005.020535] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1005.020549] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1005.022849] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04B7, 92 bytes at 183[23]:4
[ 1005.022904] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1005.024003] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1005.024036] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1005.169445] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1005.169457] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1005.277073] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1005.277089] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1005.375029] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1005.375038] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1005.383051] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1005.383061] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1005.447161] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1005.447171] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1005.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B8, 12 bytes at 184[24]:4
[ 1005.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1006.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B9, 12 bytes at 185[25]:4
[ 1006.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1007.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BA, 12 bytes at 186[26]:4
[ 1007.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1008.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BB, 12 bytes at 187[27]:4
[ 1008.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1008.876527] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.876541] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1009.053153] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1009.053167] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1009.055467] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04BC, 92 bytes at 188[28]:4
[ 1009.055528] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1009.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BD, 12 bytes at 189[29]:4
[ 1009.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1010.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BE, 12 bytes at 190[30]:4
[ 1010.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1011.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BF, 12 bytes at 191[31]:4
[ 1011.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1012.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C0, 12 bytes at 192[0]:4
[ 1012.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1013.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C1, 12 bytes at 193[1]:4
[ 1013.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1014.176060] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1014.176070] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1014.176076] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1014.176086] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04C2, 96 bytes at 194[2]:4
[ 1014.176139] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1014.176156] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1014.176162] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1014.176169] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1014.176177] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1014.176185] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1014.176202] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1014.176211] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1014.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C3, 12 bytes at 195[3]:4
[ 1014.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1015.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C4, 12 bytes at 196[4]:4
[ 1015.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1016.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C5, 12 bytes at 197[5]:4
[ 1016.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1017.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C6, 12 bytes at 198[6]:4
[ 1017.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1018.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C7, 12 bytes at 199[7]:4
[ 1018.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1019.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C8, 12 bytes at 200[8]:4
[ 1019.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1020.619154] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1020.619167] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1020.619210] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1020.619218] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1020.619253] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1020.619261] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1020.621485] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04C9, 92 bytes at 201[9]:4
[ 1020.621546] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1020.706055] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CA, 12 bytes at 202[10]:4
[ 1020.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1020.756032] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1020.756040] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1020.756047] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1020.756056] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04CB, 96 bytes at 203[11]:4
[ 1020.756107] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1020.756124] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1020.756131] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1020.756138] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1020.756146] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1020.756153] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1020.756168] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1020.756176] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1022.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CC, 12 bytes at 204[12]:4
[ 1022.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1023.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CD, 12 bytes at 205[13]:4
[ 1023.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1024.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CE, 12 bytes at 206[14]:4
[ 1024.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1025.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CF, 12 bytes at 207[15]:4
[ 1025.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1025.763717] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1025.763729] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1026.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D0, 12 bytes at 208[16]:4
[ 1026.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1027.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D1, 12 bytes at 209[17]:4
[ 1027.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1028.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D2, 12 bytes at 210[18]:4
[ 1028.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1029.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D3, 12 bytes at 211[19]:4
[ 1029.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1030.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D4, 12 bytes at 212[20]:4
[ 1030.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1030.896078] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1030.896088] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1030.896095] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1030.896105] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04D5, 96 bytes at 213[21]:4
[ 1030.896161] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1030.896196] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1030.896203] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1030.896210] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1030.896219] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1030.896226] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1030.896244] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1030.896253] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1031.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D6, 12 bytes at 214[22]:4
[ 1031.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1032.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D7, 12 bytes at 215[23]:4
[ 1032.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1033.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D8, 12 bytes at 216[24]:4
[ 1033.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1034.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D9, 12 bytes at 217[25]:4
[ 1034.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1035.195438] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1035.195453] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1035.400004] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1035.400014] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1035.400073] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1035.400083] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1035.400090] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1035.400100] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04DA, 96 bytes at 218[26]:4
[ 1035.400161] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1035.400195] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1035.400203] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1035.400210] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1035.400219] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1035.400226] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1035.400242] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1035.400250] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1035.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DB, 12 bytes at 219[27]:4
[ 1035.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1036.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DC, 12 bytes at 220[28]:4
[ 1036.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1037.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DD, 12 bytes at 221[29]:4
[ 1037.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1038.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DE, 12 bytes at 222[30]:4
[ 1038.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1038.880614] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.880628] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1039.065970] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1039.065983] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1039.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DF, 12 bytes at 223[31]:4
[ 1039.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1040.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E0, 12 bytes at 224[0]:4
[ 1040.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1041.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E1, 12 bytes at 225[1]:4
[ 1041.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1042.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E2, 12 bytes at 226[2]:4
[ 1042.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1043.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E3, 12 bytes at 227[3]:4
[ 1043.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1044.192083] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1044.192094] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1044.192101] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1044.192110] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04E4, 96 bytes at 228[4]:4
[ 1044.192166] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1044.192190] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1044.192197] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1044.192204] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1044.192212] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1044.192220] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1044.192238] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1044.192246] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1044.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E5, 12 bytes at 229[5]:4
[ 1044.706073] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1045.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E6, 12 bytes at 230[6]:4
[ 1045.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1046.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E7, 12 bytes at 231[7]:4
[ 1046.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1047.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E8, 12 bytes at 232[8]:4
[ 1047.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1048.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E9, 12 bytes at 233[9]:4
[ 1048.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1049.317759] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1049.317770] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1049.317776] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1049.317787] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04EA, 96 bytes at 234[10]:4
[ 1049.317833] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1049.317859] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1049.317866] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1049.317873] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1049.317882] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1049.317889] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1049.317908] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1049.317918] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1049.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EB, 12 bytes at 235[11]:4
[ 1049.706073] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1050.621495] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1050.621507] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1050.621549] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1050.621557] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1050.623811] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04EC, 92 bytes at 236[12]:4
[ 1050.623869] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1050.623899] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0
[ 1050.623908] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1050.623915] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1050.623922] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1050.623931] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04ED, 96 bytes at 237[13]:4
[ 1050.623983] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1050.623999] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1050.624035] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1050.624047] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1050.624060] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1050.624073] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1050.624116] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1050.624127] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1050.624939] ieee80211 phy0: U iwlagn_tx_queue_set_status Activate BA Queue 10 on FIFO 1
[ 1050.624950] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04EE, 92 bytes at 238[14]:4
[ 1050.625034] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1052.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EF, 12 bytes at 239[15]:4
[ 1052.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1053.706056] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F0, 12 bytes at 240[16]:4
[ 1053.706093] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1054.323590] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1054.323603] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1054.706054] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F1, 12 bytes at 241[17]:4
[ 1054.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1055.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F2, 12 bytes at 242[18]:4
[ 1055.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1056.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F3, 12 bytes at 243[19]:4
[ 1056.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1056.954139] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1056.954152] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1057.706037] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F4, 12 bytes at 244[20]:4
[ 1057.706073] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1058.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F5, 12 bytes at 245[21]:4
[ 1058.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1059.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F6, 12 bytes at 246[22]:4
[ 1059.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1060.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F7, 12 bytes at 247[23]:4
[ 1060.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1061.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F8, 12 bytes at 248[24]:4
[ 1061.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1062.081590] ieee80211 phy0: U iwlagn_tx_queue_set_status Deactivate AC/CMD Queue 10 on FIFO 1
[ 1062.400079] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1062.400089] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1062.400095] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1062.400105] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04F9, 96 bytes at 249[25]:4
[ 1062.400161] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1062.400184] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1062.400191] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1062.400198] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1062.400206] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1062.400214] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1062.400232] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1062.400241] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1062.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FA, 12 bytes at 250[26]:4
[ 1062.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1063.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FB, 12 bytes at 251[27]:4
[ 1063.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1064.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FC, 12 bytes at 252[28]:4
[ 1064.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1065.205460] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1065.205474] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1065.408872] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1065.408882] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1065.408935] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1065.408945] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1065.408952] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1065.408962] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04FD, 96 bytes at 253[29]:4
[ 1065.409050] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1065.409069] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1065.409076] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1065.409083] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1065.409092] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1065.409099] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1065.409115] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1065.409123] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1065.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FE, 12 bytes at 254[30]:4
[ 1065.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1066.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FF, 12 bytes at 255[31]:4
[ 1066.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1067.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0400, 12 bytes at 0[0]:4
[ 1067.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1068.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0401, 12 bytes at 1[1]:4
[ 1068.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1068.726072] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.726083] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.883635] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.883647] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.982070] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.982080] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1069.052919] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1069.052933] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1070.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0402, 12 bytes at 2[2]:4
[ 1070.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1071.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0403, 12 bytes at 3[3]:4
[ 1071.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1072.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0404, 12 bytes at 4[4]:4
[ 1072.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1073.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0405, 12 bytes at 5[5]:4
[ 1073.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1074.176063] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1074.176073] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1074.176080] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1074.176090] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0406, 96 bytes at 6[6]:4
[ 1074.176146] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1074.176170] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1074.176176] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1074.176184] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1074.176192] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1074.176199] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1074.176218] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1074.176228] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1074.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12 bytes at 7[7]:4
[ 1074.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1075.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
[ 1075.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1076.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12 bytes at 9[9]:4
[ 1076.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1077.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040A, 12 bytes at 10[10]:4
[ 1077.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1078.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040B, 12 bytes at 11[11]:4
[ 1078.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1079.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040C, 12 bytes at 12[12]:4
[ 1079.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1080.644512] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1080.644526] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1080.644567] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1080.644575] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1080.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040D, 12 bytes at 13[13]:4
[ 1080.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1080.778688] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1080.778697] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1080.778703] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1080.778713] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040E, 96 bytes at 14[14]:4
[ 1080.778764] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1080.778791] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1080.778797] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1080.778804] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1080.778812] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1080.778819] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1080.778835] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1080.778844] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1082.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040F, 12 bytes at 15[15]:4
[ 1082.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1083.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0410, 12 bytes at 16[16]:4
[ 1083.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1084.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0411, 12 bytes at 17[17]:4
[ 1084.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1085.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0412, 12 bytes at 18[18]:4
[ 1085.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1085.783452] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1085.783465] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1085.785550] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0413, 92 bytes at 19[19]:4
[ 1085.785604] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1086.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0414, 12 bytes at 20[20]:4
[ 1086.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1087.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12 bytes at 21[21]:4
[ 1087.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1088.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0416, 12 bytes at 22[22]:4
[ 1088.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1089.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0417, 12 bytes at 23[23]:4
[ 1089.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1090.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0418, 12 bytes at 24[24]:4
[ 1090.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1090.912064] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1090.912075] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1090.912081] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1090.912091] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0419, 96 bytes at 25[25]:4
[ 1090.912146] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1090.912170] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1090.912177] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1090.912184] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1090.912192] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1090.912200] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1090.912219] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1090.912229] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1091.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041A, 12 bytes at 26[26]:4
[ 1091.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1092.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041B, 12 bytes at 27[27]:4
[ 1092.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1093.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041C, 12 bytes at 28[28]:4
[ 1093.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1093.813726] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1093.813743] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1093.814738] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1093.814750] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.047202] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.047213] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.047266] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1094.047276] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1094.047283] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1094.047292] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041D, 96 bytes at 29[29]:4
[ 1094.047359] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1094.047393] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1094.047400] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1094.047407] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1094.047415] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1094.047422] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1094.047438] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.047447] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.047863] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.047873] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.302541] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.302553] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.308231] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.308240] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.308283] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.308292] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.311979] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.311990] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.597964] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.597973] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.601682] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041E, 92 bytes at 30[30]:4
[ 1094.601742] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1094.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041F, 12 bytes at 31[31]:4
[ 1094.706073] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1094.849388] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.849395] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1094.851738] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0420, 92 bytes at 32[0]:4
[ 1094.851794] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1095.205485] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1095.205499] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1095.414182] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1095.414192] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1096.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0421, 12 bytes at 33[1]:4
[ 1096.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1097.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0422, 12 bytes at 34[2]:4
[ 1097.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1098.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0423, 12 bytes at 35[3]:4
[ 1098.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1098.887718] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.887732] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1099.057838] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1099.057851] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1099.568054] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1099.568065] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1099.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0424, 12 bytes at 36[4]:4
[ 1099.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1100.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0425, 12 bytes at 37[5]:4
[ 1100.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1101.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0426, 12 bytes at 38[6]:4
[ 1101.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1102.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0427, 12 bytes at 39[7]:4
[ 1102.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1103.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0428, 12 bytes at 40[8]:4
[ 1103.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1104.656077] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1104.656087] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1104.656094] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1104.656104] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0429, 96 bytes at 41[9]:4
[ 1104.656160] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1104.656184] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1104.656191] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1104.656198] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1104.656206] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1104.656213] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1104.656232] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1104.656241] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1104.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042A, 12 bytes at 42[10]:4
[ 1104.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1105.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042B, 12 bytes at 43[11]:4
[ 1105.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1106.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042C, 12 bytes at 44[12]:4
[ 1106.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1107.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042D, 12 bytes at 45[13]:4
[ 1107.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1108.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042E, 12 bytes at 46[14]:4
[ 1108.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1109.454977] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1109.454990] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1109.455046] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1109.455054] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1109.455061] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1109.455071] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x042F, 96 bytes at 47[15]:4
[ 1109.455176] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1109.455213] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1109.455220] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1109.455227] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1109.455235] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1109.455242] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1109.455257] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1109.455265] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1109.503066] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1109.503075] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1109.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0430, 12 bytes at 48[16]:4
[ 1109.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1110.668912] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1110.668924] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1110.668966] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1110.668974] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1110.671229] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0431, 92 bytes at 49[17]:4
[ 1110.671289] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1112.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0432, 12 bytes at 50[18]:4
[ 1112.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1113.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0433, 12 bytes at 51[19]:4
[ 1113.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1114.463297] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1114.463310] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1114.465960] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0434, 92 bytes at 52[20]:4
[ 1114.466044] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1114.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0435, 12 bytes at 53[21]:4
[ 1114.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1115.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0436, 12 bytes at 54[22]:4
[ 1115.706143] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1116.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0437, 12 bytes at 55[23]:4
[ 1116.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1116.961496] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1116.961508] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1117.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0438, 12 bytes at 56[24]:4
[ 1117.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1118.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0439, 12 bytes at 57[25]:4
[ 1118.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1119.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043A, 12 bytes at 58[26]:4
[ 1119.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1120.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043B, 12 bytes at 59[27]:4
[ 1120.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1121.706056] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043C, 12 bytes at 60[28]:4
[ 1121.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1122.400083] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1122.400093] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1122.400100] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1122.400110] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x043D, 96 bytes at 61[29]:4
[ 1122.400165] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1122.400188] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1122.400195] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1122.400203] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1122.400211] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1122.400218] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1122.400236] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1122.400246] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1122.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043E, 12 bytes at 62[30]:4
[ 1122.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1123.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043F, 12 bytes at 63[31]:4
[ 1123.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1124.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0440, 12 bytes at 64[0]:4
[ 1124.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1125.205458] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1125.205470] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1125.409869] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1125.409879] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1125.409934] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1125.409944] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1125.409951] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1125.409961] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0441, 96 bytes at 65[1]:4
[ 1125.410105] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1125.410292] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1125.410299] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1125.410307] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1125.410315] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1125.410322] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1125.410340] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1125.410348] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1125.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0442, 12 bytes at 66[2]:4
[ 1125.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1126.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0443, 12 bytes at 67[3]:4
[ 1126.707397] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1127.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0444, 12 bytes at 68[4]:4
[ 1127.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1128.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0445, 12 bytes at 69[5]:4
[ 1128.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1128.891550] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.891562] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1129.068928] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1129.068941] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1129.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0446, 12 bytes at 70[6]:4
[ 1129.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1130.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0447, 12 bytes at 71[7]:4
[ 1130.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1131.504123] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1131.504137] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1131.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0448, 12 bytes at 72[8]:4
[ 1131.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1132.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0449, 12 bytes at 73[9]:4
[ 1132.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1133.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044A, 12 bytes at 74[10]:4
[ 1133.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1134.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044B, 12 bytes at 75[11]:4
[ 1134.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1135.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044C, 12 bytes at 76[12]:4
[ 1135.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1136.513229] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1136.513242] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1136.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044D, 12 bytes at 77[13]:4
[ 1136.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1137.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044E, 12 bytes at 78[14]:4
[ 1137.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1138.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044F, 12 bytes at 79[15]:4
[ 1138.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1139.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0450, 12 bytes at 80[16]:4
[ 1139.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1140.672154] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1140.672167] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1140.672209] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1140.672218] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1140.674481] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0451, 92 bytes at 81[17]:4
[ 1140.674544] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1140.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0452, 12 bytes at 82[18]:4
[ 1140.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1142.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0453, 12 bytes at 83[19]:4
[ 1142.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1143.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0454, 12 bytes at 84[20]:4
[ 1143.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1144.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0455, 12 bytes at 85[21]:4
[ 1144.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1145.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0456, 12 bytes at 86[22]:4
[ 1145.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1145.952078] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1145.952087] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1145.952094] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1145.952104] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0457, 96 bytes at 87[23]:4
[ 1145.952159] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1145.952193] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1145.952200] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1145.952207] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1145.952216] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1145.952223] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1145.952240] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1145.952250] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1146.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0458, 12 bytes at 88[24]:4
[ 1146.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1147.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0459, 12 bytes at 89[25]:4
[ 1147.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1148.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045A, 12 bytes at 90[26]:4
[ 1148.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1149.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045B, 12 bytes at 91[27]:4
[ 1149.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1150.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045C, 12 bytes at 92[28]:4
[ 1150.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1151.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045D, 12 bytes at 93[29]:4
[ 1151.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1152.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045E, 12 bytes at 94[30]:4
[ 1152.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1153.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045F, 12 bytes at 95[31]:4
[ 1153.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1154.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0460, 12 bytes at 96[0]:4
[ 1154.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1155.218524] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1155.218538] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1155.221607] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0461, 92 bytes at 97[1]:4
[ 1155.221669] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1155.423431] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1155.423441] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1155.423501] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1155.423511] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1155.423518] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1155.423528] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0462, 96 bytes at 98[2]:4
[ 1155.423629] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1155.423655] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1155.423661] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1155.423669] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1155.423677] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1155.423684] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1155.423700] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1155.423709] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1155.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0463, 12 bytes at 99[3]:4
[ 1155.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1156.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0464, 12 bytes at 100[4]:4
[ 1156.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1157.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0465, 12 bytes at 101[5]:4
[ 1157.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1158.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0466, 12 bytes at 102[6]:4
[ 1158.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1158.895186] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.895201] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1159.062790] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1159.062803] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1159.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0467, 12 bytes at 103[7]:4
[ 1159.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1160.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0468, 12 bytes at 104[8]:4
[ 1160.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1161.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0469, 12 bytes at 105[9]:4
[ 1161.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1162.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046A, 12 bytes at 106[10]:4
[ 1162.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1163.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046B, 12 bytes at 107[11]:4
[ 1163.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1164.192082] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1164.192092] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1164.192099] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1164.192109] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x046C, 96 bytes at 108[12]:4
[ 1164.192165] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1164.192188] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1164.192195] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1164.192203] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1164.192211] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1164.192218] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1164.192237] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1164.192247] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1164.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046D, 12 bytes at 109[13]:4
[ 1164.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1165.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046E, 12 bytes at 110[14]:4
[ 1165.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1166.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046F, 12 bytes at 111[15]:4
[ 1166.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1167.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0470, 12 bytes at 112[16]:4
[ 1167.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1168.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0471, 12 bytes at 113[17]:4
[ 1168.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1169.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0472, 12 bytes at 114[18]:4
[ 1169.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1170.675157] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1170.675170] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1170.675211] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1170.675219] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1170.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0473, 12 bytes at 115[19]:4
[ 1170.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1170.809283] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1170.809293] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1170.809300] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1170.809310] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0474, 96 bytes at 116[20]:4
[ 1170.809361] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1170.809378] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1170.809384] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1170.809391] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1170.809399] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1170.809407] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1170.809422] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1170.809430] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1172.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0475, 12 bytes at 117[21]:4
[ 1172.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1173.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0476, 12 bytes at 118[22]:4
[ 1173.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1174.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0477, 12 bytes at 119[23]:4
[ 1174.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1175.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0478, 12 bytes at 120[24]:4
[ 1175.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1175.813048] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1175.813061] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1176.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0479, 12 bytes at 121[25]:4
[ 1176.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1176.968127] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1176.968139] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1178.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047A, 12 bytes at 122[26]:4
[ 1178.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1179.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047B, 12 bytes at 123[27]:4
[ 1179.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1180.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047C, 12 bytes at 124[28]:4
[ 1180.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1181.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047D, 12 bytes at 125[29]:4
[ 1181.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)


On Mon, 14 Nov 2011 13:22:30 -0800
wwguy <wey-yi.w.guy@intel.com> wrote:

> ok, there were changes in this area to trigger faster in order to
> address some performance issue. 
> 
> so I believe more logic need to go in and delay the trigger in some
> cases.
> 
> Would you be able to test for me if I have a patch for testing?
> 
> Thanks
> Wey
> 
> On Mon, 2011-11-14 at 13:18 -0800, Lars Schotte wrote:
> > of course he deactivates the aggregation soon after, because the AP
> > sees no reason why there should be one.
> > 
> > triggering the aggreggation is that problem and it exists only since
> > 3.0.9. 3.0.8 is OK, but 3.1.1 seems to be affected as well. 3.1.0
> > was OK.
> > 
> > so someting broke it recently.
> > 
> > unfortunately i can not remember if 3.2 kernel had that problem, i
> > already removed it because it was too unstable for me, so i can not
> > test it any more (w/o compiling it again).
> > 
> > On Mon, 14 Nov 2011 12:38:21 -0800
> > wwguy <wey-yi.w.guy@intel.com> wrote:
> > 
> > > Hi Schotte,
> > > 
> > > looks like driver has problem activate the aggregation, you can
> > > see in the log, the aggregation queue being activate then
> > > deactivate soon after. that is why you are seeing the messages
> > > showing up in dmesg log.
> > > 
> > > what AP you are using? is similar thing happen if you connect to
> > > different AP?
> > > 
> > > Thanks
> > > Wey
> > 
> > 
> 
> 



-- 
Lars Schotte
@ Hana (F16)
