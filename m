Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:49601 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1KNWaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 17:30:12 -0500
Date: Mon, 14 Nov 2011 23:28:52 +0100
From: Lars Schotte <gusto@guttok.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn 3.0.9 aggreggation messages
Message-ID: <20111114232852.2372a032@hana.gusto> (sfid-20111114_233020_106378_0C9AAE3A)
In-Reply-To: <1321307098.1796.14.camel@wwguy-ubuntu>
References: <20111114131642.31e8ddbd@hana.gusto>
	<1321283410.13578.33.camel@wwguy-ubuntu>
	<20111114201947.58d5fdf6@hana.gusto>
	<1321303101.1796.8.camel@wwguy-ubuntu>
	<20111114221847.2ca32e6a@hana.gusto>
	<1321305750.1796.11.camel@wwguy-ubuntu>
	<20111114224718.491c1777@hana.gusto>
	<1321307098.1796.14.camel@wwguy-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

somehow it doesnt appear to 3.1.1 any more. i dont know why.
maybe it is fixed in 3.1.1, or i simply can not reproduce it.
however, there are some logs here on 3.1.1:

211 phy0: I iwlagn_mac_tx enter
[ 1007.959645] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.023438] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.023453] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.200185] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.200195] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.275494] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.275505] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.275545] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.275554] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.275591] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.275600] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.278375] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x040F, 92 bytes at 15[15]:4
[ 1008.278437] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1008.332053] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1008.435899] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.435909] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.536410] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.536421] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.628047] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.628057] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.756199] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.756209] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1008.961500] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1008.961512] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1009.963001] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1009.963035] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1010.964874] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1010.964888] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1011.966574] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1011.966588] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1012.967772] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1012.967791] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1013.969731] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1013.969747] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1014.923089] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1014.923103] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1014.971590] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1014.971603] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1014.980084] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0410, 92 bytes at 16[16]:4
[ 1014.980137] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1015.973084] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1015.973099] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1016.490490] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1016.490503] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1016.974973] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1016.974992] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1017.976523] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1017.976538] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1018.976655] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1018.976666] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1018.978072] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1018.978079] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1018.979933] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0411, 92 bytes at 17[17]:4
[ 1018.979979] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1019.600074] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1019.600090] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1019.980067] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1019.980083] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1020.981629] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1020.981645] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1021.983192] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1021.983208] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1022.984738] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1022.984752] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1023.986278] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1023.986294] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1024.987835] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1024.987851] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1025.989404] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1025.989420] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1026.990940] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1026.990955] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1026.993368] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0412, 92 bytes at 18[18]:4
[ 1026.993421] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1027.992544] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1027.992559] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1028.914311] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1028.993606] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1028.993622] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1029.995388] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1029.995403] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1030.996911] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1030.996926] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1031.998453] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1031.998468] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1033.000088] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1033.000104] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1034.001615] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1034.001630] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1035.003131] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1035.003146] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1035.005550] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0413, 92 bytes at 19[19]:4
[ 1035.005636] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1036.004896] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1036.004911] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1037.006421] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1037.006436] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.007842] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.007858] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.028493] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.028507] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.206237] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.206247] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.305907] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.305917] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.305956] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.305965] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.306001] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.306030] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.537397] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.537408] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1038.539786] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0414, 92 bytes at 20[20]:4
[ 1038.539840] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1038.750401] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1038.750416] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1039.009398] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1039.009414] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1040.010945] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1040.010960] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1041.012646] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1041.012661] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1042.014175] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1042.014192] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1043.015721] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1043.015736] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1044.017266] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1044.017280] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1045.018801] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1045.018815] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1045.021202] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0415, 92 bytes at 21[21]:4
[ 1045.021254] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1046.020379] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1046.020394] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1047.021915] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1047.021930] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1048.023103] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1048.023118] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1049.024795] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1049.024810] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1050.026304] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1050.026317] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1051.027831] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1051.027846] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1052.029361] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1052.029375] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1053.030887] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1053.030901] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1053.033282] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0416, 92 bytes at 22[22]:4
[ 1053.033335] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1054.032466] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1054.032481] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1054.034862] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0417, 92 bytes at 23[23]:4
[ 1054.034915] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1055.034062] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1055.034076] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1055.035929] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1055.035939] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1056.035152] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1056.035167] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1057.036686] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1057.036700] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1058.038209] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1058.038223] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1059.039743] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1059.039759] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1060.041285] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1060.041300] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1061.042110] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1061.042125] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1061.339086] ieee80211 phy0: U iwlagn_mac_set_key enter
[ 1061.339096] ieee80211 phy0: U iwl_scan_cancel_timeout Scan cancel timeout
[ 1061.339102] ieee80211 phy0: U iwl_do_scan_abort Not performing scan to abort
[ 1061.339112] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1061.339120] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1061.339127] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1061.339137] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0418, 96 bytes at 24[24]:4
[ 1061.339197] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1061.339224] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1061.339231] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1061.339239] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1061.339248] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1061.339255] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1061.339265] ieee80211 phy0: U iwlagn_mac_set_key disable hwcrypto key
[ 1061.339271] ieee80211 phy0: U iwlagn_mac_set_key leave
[ 1061.339368] ieee80211 phy0: U iwlagn_mac_set_key enter
[ 1061.339374] ieee80211 phy0: U iwl_scan_cancel_timeout Scan cancel timeout
[ 1061.339380] ieee80211 phy0: U iwl_do_scan_abort Not performing scan to abort
[ 1061.339389] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1061.339396] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1061.339403] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1061.339414] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0419, 96 bytes at 25[25]:4
[ 1061.339467] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1061.339486] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1061.339493] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1061.339501] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1061.339511] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1061.339519] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1061.339529] ieee80211 phy0: U iwlagn_mac_set_key enable hwcrypto key
[ 1061.339534] ieee80211 phy0: U iwlagn_mac_set_key leave
[ 1061.339590] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1061.339601] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1061.341970] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041A, 92 bytes at 26[26]:4
[ 1061.342035] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1062.043630] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1062.043644] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1063.045168] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1063.045183] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1063.845141] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1063.845154] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1064.046717] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1064.046733] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1065.048140] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1065.048156] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1066.049718] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1066.049736] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1067.051268] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1067.051282] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.031473] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.031488] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.052796] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.052807] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.055467] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041B, 92 bytes at 27[27]:4
[ 1068.055520] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1068.203210] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.203222] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.336307] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.336317] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.336358] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.336366] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.336402] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.336411] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.436663] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.436673] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.538485] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.538496] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1068.758258] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1068.758268] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1069.054649] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1069.054665] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1069.057596] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041C, 92 bytes at 28[28]:4
[ 1069.057649] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1070.055777] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1070.055792] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1071.057649] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1071.057665] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1072.059210] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1072.059226] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1073.060740] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1073.060755] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1074.062275] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1074.062290] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1075.063805] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1075.063819] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1076.065342] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1076.065356] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1077.066862] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1077.066877] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1077.069274] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041D, 92 bytes at 29[29]:4
[ 1077.069328] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1078.068453] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1078.068467] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1079.070002] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1079.070037] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1080.071581] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1080.071597] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1081.073133] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1081.073147] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1082.074658] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1082.074672] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1083.076071] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1083.076089] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1084.077223] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1084.077239] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1085.078782] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1085.078797] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1086.080330] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1086.080345] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1087.081862] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1087.081876] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1087.084278] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041E, 92 bytes at 30[30]:4
[ 1087.084333] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1088.083458] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1088.083471] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1088.085872] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041F, 92 bytes at 31[31]:4
[ 1088.085927] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1089.085059] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1089.085074] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1090.086557] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1090.086571] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1090.661109] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1091.086361] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1091.086374] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1091.088073] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1091.088083] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1092.089386] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1092.089400] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1093.090915] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1093.090929] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1093.093486] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0420, 92 bytes at 32[0]:4
[ 1093.093541] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1094.092641] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1094.092655] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1095.094198] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1095.094214] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1096.095740] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1096.095755] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1097.097209] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1097.097223] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.034529] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.034544] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.098718] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.098728] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.210888] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.210900] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.341117] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.341128] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.341168] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.341177] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.341214] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.341222] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.539227] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.539238] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1098.755496] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1098.755515] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1099.100245] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1099.100260] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1100.101779] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1100.101793] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1100.104546] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0421, 92 bytes at 33[1]:4
[ 1100.104599] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1101.103714] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1101.103729] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1102.104970] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1102.104986] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1103.106234] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1103.106248] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1104.107866] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1104.107880] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1105.109821] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1105.109835] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1106.111382] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1106.111398] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1107.112110] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1107.112125] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1107.114852] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0422, 92 bytes at 34[2]:4
[ 1107.114905] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1108.113077] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1108.113091] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1108.115489] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0423, 92 bytes at 35[3]:4
[ 1108.115541] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1108.550258] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1108.550270] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1109.114667] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1109.114683] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1110.116216] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1110.116231] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1111.117847] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1111.117863] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1111.243354] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1112.119658] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1112.119672] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1113.121190] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1113.121204] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1113.124465] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0424, 92 bytes at 36[4]:4
[ 1113.124519] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1114.122631] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1114.122646] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1114.125050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0425, 92 bytes at 37[5]:4
[ 1114.125103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1115.124235] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1115.124251] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1116.125783] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1116.125799] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1117.127334] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1117.127349] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1118.128865] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1118.128879] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1119.130419] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1119.130435] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1120.131980] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1120.131996] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1121.133868] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1121.133883] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1122.135419] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1122.135432] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1122.137819] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0426, 92 bytes at 38[6]:4
[ 1122.137871] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1123.136983] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1123.136998] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1123.139398] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0427, 92 bytes at 39[7]:4
[ 1123.139454] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1124.138576] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1124.138590] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1125.140146] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1125.140161] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1126.141689] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1126.141705] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1127.143076] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1127.143091] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1127.145494] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1127.145504] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.053450] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.053465] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.144637] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.144648] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.240743] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.240754] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.241585] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0428, 92 bytes at 40[8]:4
[ 1128.241640] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1128.343125] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.343135] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.343175] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.343183] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.343221] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.343229] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.343380] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0429, 92 bytes at 41[9]:4
[ 1128.343440] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1128.438462] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.438472] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.540071] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.540082] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1128.751194] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1128.751204] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1129.146174] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1129.146188] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1130.147692] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1130.147706] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1131.149438] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1131.149451] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1132.150947] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1132.150961] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1132.153365] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042A, 92 bytes at 42[10]:4
[ 1132.153418] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1133.152531] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1133.152545] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1133.155225] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042B, 92 bytes at 43[11]:4
[ 1133.155277] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1134.154385] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1134.154399] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1135.156326] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1135.156340] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1136.157852] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1136.157865] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1137.159388] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1137.159402] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1138.161230] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1138.161245] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1138.164077] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042C, 92 bytes at 44[12]:4
[ 1138.164130] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1139.163278] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1139.163294] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1140.164843] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1140.164857] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1140.472085] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1140.472097] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1141.166373] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1141.166387] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1142.167944] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1142.167958] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1143.169804] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1143.169818] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1143.728076] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1143.728089] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1144.171340] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1144.171354] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1145.173121] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1145.173136] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1146.174632] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1146.174646] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1147.176166] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1147.176180] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1148.177507] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1148.177521] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1149.179059] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1149.179073] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1149.181469] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042D, 92 bytes at 45[13]:4
[ 1149.181521] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1150.180643] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1150.180657] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1151.182158] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1151.182173] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1152.183681] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1152.183696] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1153.185210] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1153.185224] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1154.187072] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1154.187086] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1155.188593] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1155.188609] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1156.190157] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1156.190173] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1157.191923] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1157.191938] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1157.194351] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042E, 92 bytes at 46[14]:4
[ 1157.194404] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1158.082586] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.082601] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.193075] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.193087] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.258231] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.258243] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.348123] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.348133] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.348173] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.348182] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.348218] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.348226] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.540481] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.540495] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.754454] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1158.754468] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1158.756585] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x042F, 92 bytes at 47[15]:4
[ 1158.756638] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1160.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0430, 12 bytes at 48[16]:4
[ 1160.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1161.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0431, 12 bytes at 49[17]:4
[ 1161.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1162.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0432, 12 bytes at 50[18]:4
[ 1162.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1163.206103] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1163.206119] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1163.208464] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0433, 92 bytes at 51[19]:4
[ 1163.208524] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1163.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0434, 12 bytes at 52[20]:4
[ 1163.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1164.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0435, 12 bytes at 53[21]:4
[ 1164.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1165.706060] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0436, 12 bytes at 54[22]:4
[ 1165.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1166.706059] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0437, 12 bytes at 55[23]:4
[ 1166.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1167.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0438, 12 bytes at 56[24]:4
[ 1167.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1168.334045] ieee80211 phy0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 10 on FIFO 1
[ 1168.336047] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1168.336056] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1168.336063] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1168.336073] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0439, 96 bytes at 57[25]:4
[ 1168.336127] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1168.336145] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1168.336152] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1168.336159] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1168.336168] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1168.336175] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1168.336194] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1168.336205] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1168.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043A, 12 bytes at 58[26]:4
[ 1168.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1169.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043B, 12 bytes at 59[27]:4
[ 1169.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1170.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043C, 12 bytes at 60[28]:4
[ 1170.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1171.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043D, 12 bytes at 61[29]:4
[ 1171.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1172.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043E, 12 bytes at 62[30]:4
[ 1172.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1173.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043F, 12 bytes at 63[31]:4
[ 1173.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1174.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0440, 12 bytes at 64[0]:4
[ 1174.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1175.706026] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0441, 12 bytes at 65[1]:4
[ 1175.706062] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1176.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0442, 12 bytes at 66[2]:4
[ 1176.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1177.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0443, 12 bytes at 67[3]:4
[ 1177.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1178.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0444, 12 bytes at 68[4]:4
[ 1178.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1179.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0445, 12 bytes at 69[5]:4
[ 1179.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1180.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0446, 12 bytes at 70[6]:4
[ 1180.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1181.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0447, 12 bytes at 71[7]:4
[ 1181.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1182.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0448, 12 bytes at 72[8]:4
[ 1182.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1183.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0449, 12 bytes at 73[9]:4
[ 1183.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1184.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044A, 12 bytes at 74[10]:4
[ 1184.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1185.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044B, 12 bytes at 75[11]:4
[ 1185.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1186.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044C, 12 bytes at 76[12]:4
[ 1186.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1187.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044D, 12 bytes at 77[13]:4
[ 1187.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1188.111054] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.111069] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.281544] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.281554] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.281613] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1188.281623] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1188.281631] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1188.281641] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x044E, 96 bytes at 78[14]:4
[ 1188.281734] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1188.281761] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1188.281768] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1188.281776] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1188.281784] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1188.281792] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1188.281808] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.281817] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.350114] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.350126] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.350166] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.350175] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.350212] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.350220] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.440464] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.440474] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.540766] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.540777] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x044F, 12 bytes at 79[15]:4
[ 1188.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1188.758091] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1188.758101] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1188.759580] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0450, 92 bytes at 80[16]:4
[ 1188.759633] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1190.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0451, 12 bytes at 81[17]:4
[ 1190.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1191.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0452, 12 bytes at 82[18]:4
[ 1191.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1192.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0453, 12 bytes at 83[19]:4
[ 1192.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1193.572418] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1193.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0454, 12 bytes at 84[20]:4
[ 1193.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1193.888066] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1193.888075] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1193.888082] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1193.888092] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0455, 96 bytes at 85[21]:4
[ 1193.888148] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1193.888172] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1193.888179] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1193.888187] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1193.888195] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1193.888203] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1193.888222] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1193.888233] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1194.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0456, 12 bytes at 86[22]:4
[ 1194.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1195.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0457, 12 bytes at 87[23]:4
[ 1195.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1196.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0458, 12 bytes at 88[24]:4
[ 1196.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1197.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0459, 12 bytes at 89[25]:4
[ 1197.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1198.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045A, 12 bytes at 90[26]:4
[ 1198.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1199.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045B, 12 bytes at 91[27]:4
[ 1199.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1200.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045C, 12 bytes at 92[28]:4
[ 1200.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1201.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045D, 12 bytes at 93[29]:4
[ 1201.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1202.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045E, 12 bytes at 94[30]:4
[ 1202.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1203.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x045F, 12 bytes at 95[31]:4
[ 1203.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1204.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0460, 12 bytes at 96[0]:4
[ 1204.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1205.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0461, 12 bytes at 97[1]:4
[ 1205.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1206.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0462, 12 bytes at 98[2]:4
[ 1206.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1207.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0463, 12 bytes at 99[3]:4
[ 1207.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1208.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0464, 12 bytes at 100[4]:4
[ 1208.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1209.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0465, 12 bytes at 101[5]:4
[ 1209.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1210.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0466, 12 bytes at 102[6]:4
[ 1210.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1211.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0467, 12 bytes at 103[7]:4
[ 1211.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1212.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0468, 12 bytes at 104[8]:4
[ 1212.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1213.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0469, 12 bytes at 105[9]:4
[ 1213.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1214.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046A, 12 bytes at 106[10]:4
[ 1214.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1215.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046B, 12 bytes at 107[11]:4
[ 1215.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1216.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046C, 12 bytes at 108[12]:4
[ 1216.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1217.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x046D, 12 bytes at 109[13]:4
[ 1217.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1218.139538] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.139553] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1218.142164] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x046E, 92 bytes at 110[14]:4
[ 1218.142226] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1218.315337] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.315347] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1218.315407] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1218.315417] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1218.315424] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1218.315435] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x046F, 96 bytes at 111[15]:4
[ 1218.315567] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1218.315594] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1218.315601] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1218.315608] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1218.315617] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1218.315625] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1218.315641] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.315650] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1218.353115] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.353125] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1218.353166] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.353174] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1218.353211] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.353219] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1218.541531] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.541542] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1218.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0470, 12 bytes at 112[16]:4
[ 1218.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1218.756442] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1218.756452] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1220.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0471, 12 bytes at 113[17]:4
[ 1220.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1221.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0472, 12 bytes at 114[18]:4
[ 1221.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1222.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0473, 12 bytes at 115[19]:4
[ 1222.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1223.325880] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1223.325896] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1223.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0474, 12 bytes at 116[20]:4
[ 1223.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1224.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0475, 12 bytes at 117[21]:4
[ 1224.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1225.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0476, 12 bytes at 118[22]:4
[ 1225.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1226.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0477, 12 bytes at 119[23]:4
[ 1226.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1227.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0478, 12 bytes at 120[24]:4
[ 1227.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1228.448054] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1228.448064] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1228.448071] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1228.448081] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0479, 96 bytes at 121[25]:4
[ 1228.448135] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1228.448153] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1228.448159] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1228.448167] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1228.448176] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1228.448183] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1228.448201] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1228.448212] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1228.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047A, 12 bytes at 122[26]:4
[ 1228.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1229.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047B, 12 bytes at 123[27]:4
[ 1229.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1230.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047C, 12 bytes at 124[28]:4
[ 1230.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1231.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047D, 12 bytes at 125[29]:4
[ 1231.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1232.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047E, 12 bytes at 126[30]:4
[ 1232.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1233.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x047F, 12 bytes at 127[31]:4
[ 1233.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1234.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0480, 12 bytes at 128[0]:4
[ 1234.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1234.736942] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1235.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0481, 12 bytes at 129[1]:4
[ 1235.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1236.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0482, 12 bytes at 130[2]:4
[ 1236.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1237.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0483, 12 bytes at 131[3]:4
[ 1237.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1238.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0484, 12 bytes at 132[4]:4
[ 1238.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1239.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0485, 12 bytes at 133[5]:4
[ 1239.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1240.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0486, 12 bytes at 134[6]:4
[ 1240.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1241.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0487, 12 bytes at 135[7]:4
[ 1241.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1242.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0488, 12 bytes at 136[8]:4
[ 1242.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1243.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0489, 12 bytes at 137[9]:4
[ 1243.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1244.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048A, 12 bytes at 138[10]:4
[ 1244.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1245.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048B, 12 bytes at 139[11]:4
[ 1245.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1246.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048C, 12 bytes at 140[12]:4
[ 1246.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1247.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x048D, 12 bytes at 141[13]:4
[ 1247.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1248.147496] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.147511] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.149816] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x048E, 92 bytes at 142[14]:4
[ 1248.149879] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1248.315100] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.315110] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.315173] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1248.315182] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1248.315190] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1248.315200] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x048F, 96 bytes at 143[15]:4
[ 1248.315304] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1248.315331] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1248.315343] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0490, 92 bytes at 144[16]:4
[ 1248.315357] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1248.315364] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1248.315373] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1248.315381] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1248.315400] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1248.315409] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.315420] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.356112] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.356123] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.356165] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.356174] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.356211] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.356219] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.442448] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.442458] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.542310] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.542321] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1248.706038] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0491, 12 bytes at 145[17]:4
[ 1248.706074] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1248.761833] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1248.761843] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1250.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0492, 12 bytes at 146[18]:4
[ 1250.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1251.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0493, 12 bytes at 147[19]:4
[ 1251.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1252.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0494, 12 bytes at 148[20]:4
[ 1252.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1253.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0495, 12 bytes at 149[21]:4
[ 1253.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1253.888062] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1253.888072] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1253.888079] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1253.888089] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0496, 96 bytes at 150[22]:4
[ 1253.888146] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1253.888170] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1253.888177] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1253.888185] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1253.888194] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1253.888201] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1253.888221] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1253.888231] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1253.982722] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1253.982737] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1253.983710] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1253.983722] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.205156] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.205168] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.205221] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1254.205230] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1254.205237] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1254.205248] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0497, 96 bytes at 151[23]:4
[ 1254.205346] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1254.205374] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0498, 92 bytes at 152[24]:4
[ 1254.205386] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1254.205396] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1254.205404] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1254.205416] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1254.205425] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1254.205444] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.205454] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.205481] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1254.206066] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.206082] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.207796] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0499, 92 bytes at 153[25]:4
[ 1254.207857] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1254.441606] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.441616] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.447489] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.447500] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.447557] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.447566] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.450838] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.450849] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049A, 12 bytes at 154[26]:4
[ 1254.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1254.723141] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.723151] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1254.951415] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1254.951421] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1255.265082] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1255.265096] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1255.270207] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x049B, 92 bytes at 155[27]:4
[ 1255.270266] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1255.270338] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1255.270347] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1255.270354] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1255.270364] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x049C, 96 bytes at 156[28]:4
[ 1255.270416] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1255.270437] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1255.270443] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1255.270451] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1255.270460] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1255.270468] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1255.270494] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1255.270503] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1255.271298] ieee80211 phy0: U iwl_trans_tx_queue_set_status Activate BA Queue 10 on FIFO 1
[ 1255.271309] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x049D, 92 bytes at 157[29]:4
[ 1255.271319] iwlagn 0000:02:00.0: Tx aggregation enabled on ra = 20:4e:7f:5b:2d:f5 tid = 0
[ 1255.271362] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1255.319216] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1256.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049E, 12 bytes at 158[30]:4
[ 1256.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1257.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x049F, 12 bytes at 159[31]:4
[ 1257.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1258.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A0, 12 bytes at 160[0]:4
[ 1258.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1259.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A1, 12 bytes at 161[1]:4
[ 1259.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1260.352067] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1260.352078] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1260.352084] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1260.352095] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04A2, 96 bytes at 162[2]:4
[ 1260.352152] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1260.352177] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1260.352185] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1260.352192] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1260.352201] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1260.352209] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1260.352229] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1260.352240] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1260.393681] ieee80211 phy0: U iwl_trans_tx_queue_set_status Deactivate AC/CMD Queue 10 on FIFO 1
[ 1260.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A3, 12 bytes at 163[3]:4
[ 1260.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1261.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A4, 12 bytes at 164[4]:4
[ 1261.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1262.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A5, 12 bytes at 165[5]:4
[ 1262.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1263.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A6, 12 bytes at 166[6]:4
[ 1263.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1264.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A7, 12 bytes at 167[7]:4
[ 1264.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1265.224577] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1265.224592] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1265.224649] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1265.224658] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1265.224664] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1265.224674] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04A8, 96 bytes at 168[8]:4
[ 1265.224778] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1265.224808] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1265.224815] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1265.224822] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1265.224831] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1265.224838] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1265.224852] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1265.224861] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1265.267052] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1265.267061] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1265.619080] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1265.619090] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1265.706056] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04A9, 12 bytes at 169[9]:4
[ 1265.706092] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1266.706061] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AA, 12 bytes at 170[10]:4
[ 1266.706098] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1267.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AB, 12 bytes at 171[11]:4
[ 1267.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1268.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AC, 12 bytes at 172[12]:4
[ 1268.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1268.808083] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1268.808096] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1270.235685] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1270.235700] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1271.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AD, 12 bytes at 173[13]:4
[ 1271.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1272.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AE, 12 bytes at 174[14]:4
[ 1272.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1273.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04AF, 12 bytes at 175[15]:4
[ 1273.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1274.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B0, 12 bytes at 176[16]:4
[ 1274.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1275.360110] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1275.360121] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1275.360128] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1275.360139] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04B1, 96 bytes at 177[17]:4
[ 1275.360197] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1275.360222] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1275.360229] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1275.360237] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1275.360246] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1275.360253] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1275.360272] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1275.360282] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1275.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B2, 12 bytes at 178[18]:4
[ 1275.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1275.901469] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1276.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B3, 12 bytes at 179[19]:4
[ 1276.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1277.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B4, 12 bytes at 180[20]:4
[ 1277.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1278.155534] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1278.155550] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1278.329433] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1278.329443] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1278.329506] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1278.329516] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1278.329523] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1278.329534] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04B5, 96 bytes at 181[21]:4
[ 1278.329592] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1278.329620] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1278.329627] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1278.329634] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1278.329643] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1278.329651] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1278.329667] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1278.329676] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1278.357996] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1278.358028] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1278.358079] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1278.358088] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1278.361797] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04B6, 92 bytes at 182[22]:4
[ 1278.361861] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1278.542629] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1278.542640] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1278.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B7, 12 bytes at 183[23]:4
[ 1278.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1278.756742] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1278.756752] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1280.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B8, 12 bytes at 184[24]:4
[ 1280.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1281.559607] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1281.559621] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1281.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04B9, 12 bytes at 185[25]:4
[ 1281.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1282.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BA, 12 bytes at 186[26]:4
[ 1282.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1283.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BB, 12 bytes at 187[27]:4
[ 1283.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1284.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BC, 12 bytes at 188[28]:4
[ 1284.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1285.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BD, 12 bytes at 189[29]:4
[ 1285.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1286.688080] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1286.688090] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1286.688097] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1286.688108] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04BE, 96 bytes at 190[30]:4
[ 1286.688167] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1286.688201] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1286.688209] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1286.688216] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1286.688225] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1286.688233] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1286.688253] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1286.688263] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1286.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04BF, 12 bytes at 191[31]:4
[ 1286.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1287.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C0, 12 bytes at 192[0]:4
[ 1287.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1288.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C1, 12 bytes at 193[1]:4
[ 1288.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1289.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C2, 12 bytes at 194[2]:4
[ 1289.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1290.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C3, 12 bytes at 195[3]:4
[ 1290.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1291.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C4, 12 bytes at 196[4]:4
[ 1291.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1292.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C5, 12 bytes at 197[5]:4
[ 1292.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1293.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C6, 12 bytes at 198[6]:4
[ 1293.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1294.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C7, 12 bytes at 199[7]:4
[ 1294.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1295.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C8, 12 bytes at 200[8]:4
[ 1295.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1296.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04C9, 12 bytes at 201[9]:4
[ 1296.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1297.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CA, 12 bytes at 202[10]:4
[ 1297.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1298.706058] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CB, 12 bytes at 203[11]:4
[ 1298.706096] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1299.706059] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CC, 12 bytes at 204[12]:4
[ 1299.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1300.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CD, 12 bytes at 205[13]:4
[ 1300.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1301.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CE, 12 bytes at 206[14]:4
[ 1301.706075] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1302.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04CF, 12 bytes at 207[15]:4
[ 1302.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1303.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D0, 12 bytes at 208[16]:4
[ 1303.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1304.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D1, 12 bytes at 209[17]:4
[ 1304.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1305.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D2, 12 bytes at 210[18]:4
[ 1305.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1306.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D3, 12 bytes at 211[19]:4
[ 1306.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1307.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D4, 12 bytes at 212[20]:4
[ 1307.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1308.158503] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1308.158518] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1308.371346] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1308.371355] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1308.371362] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1308.371372] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04D5, 96 bytes at 213[21]:4
[ 1308.371424] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1308.371442] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1308.371449] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1308.371456] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1308.371465] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1308.371473] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1308.371488] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1308.371497] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1308.444256] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1308.444266] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1308.543285] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1308.543295] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1308.545926] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D6, 92 bytes at 214[22]:4
[ 1308.545987] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1308.706039] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D7, 12 bytes at 215[23]:4
[ 1308.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1308.756298] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1308.756308] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1308.758601] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x04D8, 92 bytes at 216[24]:4
[ 1308.758770] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1308.783343] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1308.783352] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1310.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04D9, 12 bytes at 217[25]:4
[ 1310.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1311.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DA, 12 bytes at 218[26]:4
[ 1311.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1312.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DB, 12 bytes at 219[27]:4
[ 1312.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1313.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DC, 12 bytes at 220[28]:4
[ 1313.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1313.765514] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1313.765525] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1314.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DD, 12 bytes at 221[29]:4
[ 1314.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1315.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DE, 12 bytes at 222[30]:4
[ 1315.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1316.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04DF, 12 bytes at 223[31]:4
[ 1316.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1317.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E0, 12 bytes at 224[0]:4
[ 1317.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1318.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E1, 12 bytes at 225[1]:4
[ 1318.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1318.896076] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1318.896085] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1318.896092] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1318.896102] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04E2, 96 bytes at 226[2]:4
[ 1318.896162] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1318.896187] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1318.896194] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1318.896202] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1318.896210] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1318.896218] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1318.896237] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1318.896248] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1319.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E3, 12 bytes at 227[3]:4
[ 1319.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1320.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E4, 12 bytes at 228[4]:4
[ 1320.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1321.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E5, 12 bytes at 229[5]:4
[ 1321.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1322.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E6, 12 bytes at 230[6]:4
[ 1322.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1323.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E7, 12 bytes at 231[7]:4
[ 1323.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1324.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E8, 12 bytes at 232[8]:4
[ 1324.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1325.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04E9, 12 bytes at 233[9]:4
[ 1325.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1326.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EA, 12 bytes at 234[10]:4
[ 1326.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1327.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EB, 12 bytes at 235[11]:4
[ 1327.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1328.584954] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1328.584968] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1328.585027] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1328.585037] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1328.585044] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1328.585054] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04EC, 96 bytes at 236[12]:4
[ 1328.585119] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1328.585145] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1328.585153] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1328.585160] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1328.585169] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1328.585176] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1328.585194] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1328.585203] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1328.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04ED, 12 bytes at 237[13]:4
[ 1328.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1329.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EE, 12 bytes at 238[14]:4
[ 1329.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1330.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04EF, 12 bytes at 239[15]:4
[ 1330.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1331.706062] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F0, 12 bytes at 240[16]:4
[ 1331.706100] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1332.706060] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F1, 12 bytes at 241[17]:4
[ 1332.706097] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1333.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F2, 12 bytes at 242[18]:4
[ 1333.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1333.712073] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1333.712083] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1333.712089] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1333.712100] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04F3, 96 bytes at 243[19]:4
[ 1333.712158] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1333.712183] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1333.712190] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1333.712198] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1333.712207] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1333.712214] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1333.712234] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1333.712245] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1334.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F4, 12 bytes at 244[20]:4
[ 1334.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1335.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F5, 12 bytes at 245[21]:4
[ 1335.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1336.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F6, 12 bytes at 246[22]:4
[ 1336.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1337.648272] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1337.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F7, 12 bytes at 247[23]:4
[ 1337.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1338.161473] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1338.161489] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1338.328494] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1338.328503] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1338.328510] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1338.328520] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04F8, 96 bytes at 248[24]:4
[ 1338.328573] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1338.328591] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1338.328597] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1338.328605] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1338.328613] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1338.328621] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1338.328636] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1338.328644] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1338.366118] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1338.366128] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1338.366168] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1338.366176] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1338.544321] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1338.544332] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1338.601623] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1338.601633] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1338.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04F9, 12 bytes at 249[25]:4
[ 1338.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1338.761233] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1338.761243] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1340.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FA, 12 bytes at 250[26]:4
[ 1340.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1341.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FB, 12 bytes at 251[27]:4
[ 1341.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1342.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FC, 12 bytes at 252[28]:4
[ 1342.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1343.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FD, 12 bytes at 253[29]:4
[ 1343.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1343.888077] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1343.888087] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1343.888094] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1343.888104] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x04FE, 96 bytes at 254[30]:4
[ 1343.888161] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1343.888183] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1343.888190] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1343.888197] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1343.888206] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1343.888214] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1343.888232] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1343.888243] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1344.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x04FF, 12 bytes at 255[31]:4
[ 1344.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1345.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0400, 12 bytes at 0[0]:4
[ 1345.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1346.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0401, 12 bytes at 1[1]:4
[ 1346.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1347.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0402, 12 bytes at 2[2]:4
[ 1347.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1348.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0403, 12 bytes at 3[3]:4
[ 1348.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1349.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0404, 12 bytes at 4[4]:4
[ 1349.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1350.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0405, 12 bytes at 5[5]:4
[ 1350.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1351.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0406, 12 bytes at 6[6]:4
[ 1351.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1352.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12 bytes at 7[7]:4
[ 1352.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1353.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
[ 1353.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1354.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12 bytes at 9[9]:4
[ 1354.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1355.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040A, 12 bytes at 10[10]:4
[ 1355.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1356.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040B, 12 bytes at 11[11]:4
[ 1356.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1357.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040C, 12 bytes at 12[12]:4
[ 1357.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1358.230529] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1358.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040D, 12 bytes at 13[13]:4
[ 1358.706076] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1359.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040E, 12 bytes at 14[14]:4
[ 1359.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1360.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x040F, 12 bytes at 15[15]:4
[ 1360.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1361.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0410, 12 bytes at 16[16]:4
[ 1361.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1362.706040] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0411, 12 bytes at 17[17]:4
[ 1362.706078] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1363.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0412, 12 bytes at 18[18]:4
[ 1363.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1364.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0413, 12 bytes at 19[19]:4
[ 1364.706088] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1365.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0414, 12 bytes at 20[20]:4
[ 1365.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1366.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12 bytes at 21[21]:4
[ 1366.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1367.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0416, 12 bytes at 22[22]:4
[ 1367.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1367.929352] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1367.929370] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1367.931693] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0417, 92 bytes at 23[23]:4
[ 1367.931757] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1367.975732] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1367.975746] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1367.975810] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1367.975820] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1367.975828] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1367.975838] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0418, 96 bytes at 24[24]:4
[ 1367.975892] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1367.975918] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1367.975926] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1367.975933] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1367.975942] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1367.975949] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1367.975966] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1367.975975] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1367.976429] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1367.976440] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1367.978331] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x0419, 92 bytes at 25[25]:4
[ 1367.978386] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1367.981455] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1367.981468] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.190517] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1368.190534] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.367305] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1368.367322] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.367364] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1368.367372] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.382534] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1368.382544] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.444593] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1368.444604] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.544778] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1368.544790] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041A, 12 bytes at 26[26]:4
[ 1368.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1368.763932] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1368.763944] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1368.766245] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041B, 92 bytes at 27[27]:4
[ 1368.766306] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1370.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041C, 12 bytes at 28[28]:4
[ 1370.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1371.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041D, 12 bytes at 29[29]:4
[ 1371.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1372.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x041E, 12 bytes at 30[30]:4
[ 1372.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1372.985277] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1372.985291] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1372.988270] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x041F, 92 bytes at 31[31]:4
[ 1372.988331] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1373.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0420, 12 bytes at 32[0]:4
[ 1373.706090] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1374.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0421, 12 bytes at 33[1]:4
[ 1374.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1375.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0422, 12 bytes at 34[2]:4
[ 1375.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1376.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0423, 12 bytes at 35[3]:4
[ 1376.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1377.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0424, 12 bytes at 36[4]:4
[ 1377.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1378.112065] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1378.112075] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1378.112082] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1378.112093] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0425, 96 bytes at 37[5]:4
[ 1378.112151] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1378.112176] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1378.112183] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1378.112191] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1378.112200] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1378.112207] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1378.112227] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1378.112238] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1378.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0426, 12 bytes at 38[6]:4
[ 1378.706077] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1378.812798] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1379.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0427, 12 bytes at 39[7]:4
[ 1379.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1380.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0428, 12 bytes at 40[8]:4
[ 1380.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1381.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0429, 12 bytes at 41[9]:4
[ 1381.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1382.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042A, 12 bytes at 42[10]:4
[ 1382.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1383.706050] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042B, 12 bytes at 43[11]:4
[ 1383.706105] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1384.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042C, 12 bytes at 44[12]:4
[ 1384.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1385.706025] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042D, 12 bytes at 45[13]:4
[ 1385.706062] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1386.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042E, 12 bytes at 46[14]:4
[ 1386.706086] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1387.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x042F, 12 bytes at 47[15]:4
[ 1387.706094] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1388.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0430, 12 bytes at 48[16]:4
[ 1388.707442] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1389.706046] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0431, 12 bytes at 49[17]:4
[ 1389.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1390.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0432, 12 bytes at 50[18]:4
[ 1390.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1391.050090] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1391.050104] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1391.706041] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0433, 12 bytes at 51[19]:4
[ 1391.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1392.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0434, 12 bytes at 52[20]:4
[ 1392.706084] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1393.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0435, 12 bytes at 53[21]:4
[ 1393.706085] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1394.064092] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1394.064112] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1394.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0436, 12 bytes at 54[22]:4
[ 1394.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1395.706049] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0437, 12 bytes at 55[23]:4
[ 1395.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1396.706048] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0438, 12 bytes at 56[24]:4
[ 1396.706095] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1397.706047] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0439, 12 bytes at 57[25]:4
[ 1397.706087] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1398.219369] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1398.219384] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1398.386448] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1398.386460] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1398.386958] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1398.386964] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1398.386968] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1398.386974] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x043A, 96 bytes at 58[26]:4
[ 1398.387044] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1398.387255] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1398.387259] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1398.387263] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1398.387268] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1398.387272] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1398.387284] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1398.387291] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1398.394165] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1398.394181] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1398.394211] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1398.394216] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1398.545517] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1398.545535] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1398.706064] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043B, 12 bytes at 59[27]:4
[ 1398.706103] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1398.758877] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1398.758889] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1398.761191] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_TX_LINK_QUALITY_CMD (#4e), seq: 0x043C, 92 bytes at 60[28]:4
[ 1398.761252] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_TX_LINK_QUALITY_CMD (0x00000000)
[ 1399.395053] ieee80211 phy0: I iwl_tt_handler Queueing thermal throttling work.
[ 1400.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043D, 12 bytes at 61[29]:4
[ 1400.706089] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1401.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043E, 12 bytes at 62[30]:4
[ 1401.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1402.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x043F, 12 bytes at 63[31]:4
[ 1402.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1403.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0440, 12 bytes at 64[0]:4
[ 1403.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1403.888082] ieee80211 phy0: U iwl_send_add_sta Adding sta 0 (20:4e:7f:5b:2d:f5) synchronously
[ 1403.888093] ieee80211 phy0: U iwl_send_cmd_sync Attempting to send sync command REPLY_ADD_STA
[ 1403.888100] ieee80211 phy0: U iwl_send_cmd_sync Setting HCMD_ACTIVE for command REPLY_ADD_STA
[ 1403.888110] ieee80211 phy0: U iwl_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0441, 96 bytes at 65[1]:4
[ 1403.888170] ieee80211 phy0: I iwl_tx_cmd_complete Clearing HCMD_ACTIVE for command REPLY_ADD_STA
[ 1403.888195] ieee80211 phy0: U iwl_process_add_sta_resp Processing response for adding station 0
[ 1403.888202] ieee80211 phy0: U iwl_process_add_sta_resp REPLY_ADD_STA PASSED
[ 1403.888210] ieee80211 phy0: U iwl_sta_ucode_activate STA id 0 addr 20:4e:7f:5b:2d:f5 already present in uCode (according to driver)
[ 1403.888218] ieee80211 phy0: U iwl_process_add_sta_resp Modified station id 0 addr 20:4e:7f:5b:2d:f5
[ 1403.888226] ieee80211 phy0: U iwl_process_add_sta_resp Modified station according to cmd buffer 20:4e:7f:5b:2d:f5
[ 1403.888246] ieee80211 phy0: I iwlagn_mac_tx enter
[ 1403.888257] ieee80211 phy0: I iwlagn_mac_tx leave
[ 1404.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0442, 12 bytes at 66[2]:4
[ 1404.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1405.706045] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0443, 12 bytes at 67[3]:4
[ 1405.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1406.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0444, 12 bytes at 68[4]:4
[ 1406.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1407.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0445, 12 bytes at 69[5]:4
[ 1407.706079] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1408.706044] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0446, 12 bytes at 70[6]:4
[ 1408.706082] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1409.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0447, 12 bytes at 71[7]:4
[ 1409.706083] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1410.706042] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0448, 12 bytes at 72[8]:4
[ 1410.706080] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)
[ 1411.706043] ieee80211 phy0: I iwl_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0449, 12 bytes at 73[9]:4
[ 1411.706081] ieee80211 phy0: I iwl_generic_cmd_callback back from REPLY_LEDS_CMD (0x00000000)


On Mon, 14 Nov 2011 13:44:58 -0800
wwguy <wey-yi.w.guy@intel.com> wrote:

> any chance to try the "auto_agg=0" module parameter?
> 
> Wey


-- 
Lars Schotte
@ Hana (F16)
