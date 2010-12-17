Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50665 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0LQRUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 12:20:33 -0500
Received: by wwa36 with SMTP id 36so888993wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 09:20:32 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 17 Dec 2010 12:20:32 -0500
Message-ID: <AANLkTikKtc4uiXN+oHwDr8sPFXZCe3HvTfYSvgZ8uYx0@mail.gmail.com>
Subject: rtl8192 does not see N networks in my building
From: Amos Blanton <amos.blanton@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings. I have a rtl8192 in a Strata 13 laptop from Zareason
running Ubuntu 10.10, and I work in an environment with many Wifi
networks. With my previous laptop I was often able to see and
sometimes login to a local un-encrypted N network, the best we have
around here, but this one doesn't seem to find and display that
network via Network Manager.
I'm told my office has cisco ap1252s running the latest 7.0 code
release. There are B/G as well as N networks here, at least 10 that
Network manager will recognize.

Sorry, I'm not sure what the relevant DMSG info is, so I'll include
the latest swath. Please let me know if I should get additional info,
and if this is the right place to report these issues.
Thanks to everyone here who helps make Linux wireless work!

-Amos

  359.748754] LPS leave: notify AP we are awaked ++++++++++ SendNullFunctionData
[  359.749098] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  359.805892] =====>rtl8192_set_chan()====ch:1
[  359.925611] =====>rtl8192_set_chan()====ch:2
[  360.045465] =====>rtl8192_set_chan()====ch:3
[  360.165430] =====>rtl8192_set_chan()====ch:4
[  360.285243] =====>rtl8192_set_chan()====ch:5
[  360.405139] =====>rtl8192_set_chan()====ch:6
[  360.524976] =====>rtl8192_set_chan()====ch:7
[  360.644919] =====>rtl8192_set_chan()====ch:8
[  360.764741] =====>rtl8192_set_chan()====ch:9
[  360.884613] =====>rtl8192_set_chan()====ch:10
[  361.004666] =====>rtl8192_set_chan()====ch:11
[  361.128624] =====>rtl8192_set_chan()====ch:12
[  361.244226] =====>rtl8192_set_chan()====ch:13
[  361.364079] =====>rtl8192_set_chan()====ch:11
[  361.374946] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  361.374958] rtl8192_update_cap(): WLAN_CAPABILITY_SHORT_PREAMBLE
[  361.380087] notify_wx_assoc_event(): Tell user space disconnected
[  361.380131] Linking with MIT,channel:6, qos:1, myHT:1, networkHT:1,
mode:10 cur_net.flags:0x40e
[  361.380217] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  361.380357] ===>rtllib_associate_procedure_wq(), chan:6
[  361.380361] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  361.380366] =====>rtl8192_set_chan()====ch:6
[  361.417746] Linking with MIT,channel:1, qos:1, myHT:1, networkHT:1,
mode:10 cur_net.flags:0x40e
[  361.417778] ===>rtllib_associate_procedure_wq(), chan:1
[  361.417785] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  361.417791] =====>rtl8192_set_chan()====ch:1
[  363.921468] Linking with MIT,channel:1, qos:1, myHT:1, networkHT:1,
mode:10 cur_net.flags:0x40e
[  363.921488] ===>rtllib_associate_procedure_wq(), chan:1
[  363.921494] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  363.921500] =====>rtl8192_set_chan()====ch:1
[  364.266878] rtl8192_SetWirelessMode(), wireless_mode:10, bEnableHT = 1
[  364.334040] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:0:2b
[  364.334044] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:1:4f
[  364.334047] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:2:22
[  364.334050] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:3:22
[  364.334056] Associated successfully
[  364.334058] normal associate
[  364.334071] Using G rates:108
[  364.334073] Successfully associated, ht enabled
[  364.334076] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  364.334080] =====>rtl8192_set_chan()====ch:1
[  364.344559] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  364.344570] rtl8192_update_cap(): WLAN_CAPABILITY_SHORT_PREAMBLE
[  364.356664] ====>rx ADDBAREQ from :00:23:eb:d1:cd:02
[  364.356684] ====>to send ADDBARSP
[  372.032996] intel ips 0000:00:1f.6: MCP power or thermal limit exceeded
[  397.106889] rtl8192_hw_wakeup(): RF Change in progress! schedule
wake up task again
[  405.090729] rtl8192_hw_sleep_down(): RF Change in progress!
[  419.074869] rtl8192_hw_sleep_down(): RF Change in progress!
[  465.026504] MgntActSet_RF_State(): RF Change in progress! Wait to
set..StateToSet(0).
[  479.622470] LPS leave: notify AP we are awaked ++++++++++
SendNullFunctionData
[  479.622768] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  479.681548] =====>rtl8192_set_chan()====ch:1
[  479.801523] =====>rtl8192_set_chan()====ch:2
[  479.920546] =====>rtl8192_set_chan()====ch:3
[  480.040420] =====>rtl8192_set_chan()====ch:4
[  480.160316] =====>rtl8192_set_chan()====ch:5
[  480.280181] =====>rtl8192_set_chan()====ch:6
[  480.400039] =====>rtl8192_set_chan()====ch:7
[  480.519937] =====>rtl8192_set_chan()====ch:8
[  480.639949] =====>rtl8192_set_chan()====ch:9
[  480.759647] =====>rtl8192_set_chan()====ch:10
[  480.879483] =====>rtl8192_set_chan()====ch:11
[  480.999424] =====>rtl8192_set_chan()====ch:12
[  481.119290] =====>rtl8192_set_chan()====ch:13
[  481.239199] =====>rtl8192_set_chan()====ch:1
[  481.250154] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  481.250165] rtl8192_update_cap(): WLAN_CAPABILITY_SHORT_PREAMBLE
[  481.255013] notify_wx_assoc_event(): Tell user space disconnected
[  481.255044] Linking with MIT,channel:6, qos:1, myHT:1, networkHT:1,
mode:10 cur_net.flags:0x40e
[  481.255108] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  481.255350] ===>rtllib_associate_procedure_wq(), chan:6
[  481.255353] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  481.255357] =====>rtl8192_set_chan()====ch:6
[  481.292927] Linking with MIT,channel:1, qos:1, myHT:1, networkHT:1,
mode:10 cur_net.flags:0x40e
[  481.293782] ===>rtllib_associate_procedure_wq(), chan:1
[  481.293791] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  481.293801] =====>rtl8192_set_chan()====ch:1
[  481.528555] rtllib: received DELBA while QOS or HT is not supported(0, 1)
[  483.796486] Linking with MIT,channel:1, qos:1, myHT:1, networkHT:1,
mode:10 cur_net.flags:0x40e
[  483.796505] ===>rtllib_associate_procedure_wq(), chan:1
[  483.796511] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  483.796517] =====>rtl8192_set_chan()====ch:1
[  486.303883] Linking with MIT,channel:1, qos:1, myHT:1, networkHT:1,
mode:10 cur_net.flags:0x40e
[  486.303895] ===>rtllib_associate_procedure_wq(), chan:1
[  486.303899] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  486.303902] =====>rtl8192_set_chan()====ch:1
[  486.356465] rtl8192_SetWirelessMode(), wireless_mode:10, bEnableHT = 1
[  486.409854] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:0:2b
[  486.409862] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:1:4f
[  486.409867] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:2:22
[  486.409873] SetHwReg8192SE():HW_VAR_AC_PARAM eACI:3:22
[  486.409883] Associated successfully
[  486.409887] normal associate
[  486.409905] Using G rates:108
[  486.409909] Successfully associated, ht enabled
[  486.409914] HTSetConnectBwMode():pHTInfo->bCurBW40MHz:0
[  486.409920] =====>rtl8192_set_chan()====ch:1
[  486.420769] ===>rtl8192se_link_change():ieee->iw_mode is 2
[  486.420779] rtl8192_update_cap(): WLAN_CAPABILITY_SHORT_PREAMBLE
[  486.432060] ====>rx ADDBAREQ from :00:23:eb:d1:cb:e2
[  486.432071] ====>to send ADDBARSP
[  512.984431] rtl8192_hw_sleep_down(): RF Change in progress!
[  518.981534] rtl8192_hw_wakeup(): RF Change in progress! schedule
wake up task again
