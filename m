Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60607 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbZGOEZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 00:25:06 -0400
Received: by fxm18 with SMTP id 18so3209932fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2009 21:25:03 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Jul 2009 21:25:02 -0700
Message-ID: <bcd1ba70907142125y35c78cf5v251953eafede0e74@mail.gmail.com>
Subject: Unable to load iwlagn module: Failed to register hw (error -17)
From: John Ranson <ranson@analager.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just installed the latest compat-wireless to get drivers for my
iwl4965 card. I can't load the iwlagn module. I'm running 2.6.30.

Is this a bug, or did I do something wrong?

John

Here is my dmesg output.

[    4.201255] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
Linux, 1.3.27kds
[    4.201258] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    4.201389] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    4.201422] iwlagn 0000:03:00.0: setting latency timer to 64
[    4.201490] ieee80211 phy0: U iwl_pci_probe pci_resource_len = 0x00002000
[    4.201493] ieee80211 phy0: U iwl_pci_probe pci_resource_base =
ffffc20004088000
[    4.201525] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link
4965AGN REV=0x4
[    4.201536] ieee80211 phy0: U iwl_prepare_card_hw iwl_prepare_card_hw enter
[    4.201546] ieee80211 phy0: U iwl_set_hw_ready hardware ready
[    4.221075] usb 1-1: new full speed USB device using uhci_hcd and address 2
[    4.252084] ieee80211 phy0: U iwl_pci_probe MAC address: 00:13:e8:d3:9e:77
[    4.252089] ieee80211 phy0: U iwl_set_rxon_chain rx_chain=0x2806
active=2 idle=2
[    4.252092] ieee80211 phy0: U iwl_init_channel_map Initializing
regulatory info from EEPROM
[    4.252095] ieee80211 phy0: U iwl_init_channel_map Parsing data for
56 channels.
[    4.252117] ieee80211 phy0: U iwl_init_channel_map Ch. 1 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252121] ieee80211 phy0: U iwl_init_channel_map Ch. 2 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252125] ieee80211 phy0: U iwl_init_channel_map Ch. 3 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252129] ieee80211 phy0: U iwl_init_channel_map Ch. 4 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252132] ieee80211 phy0: U iwl_init_channel_map Ch. 5 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252136] ieee80211 phy0: U iwl_init_channel_map Ch. 6 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252140] ieee80211 phy0: U iwl_init_channel_map Ch. 7 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252143] ieee80211 phy0: U iwl_init_channel_map Ch. 8 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252147] ieee80211 phy0: U iwl_init_channel_map Ch. 9 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252151] ieee80211 phy0: U iwl_init_channel_map Ch. 10 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252155] ieee80211 phy0: U iwl_init_channel_map Ch. 11 [2.4GHz]
VALID IBSS ACTIVE WIDE (0x2b 14dBm): Ad-Hoc supported
[    4.252158] ieee80211 phy0: U iwl_init_channel_map Ch. 12 Flags 0
[2.4GHz] - No traffic
[    4.252160] ieee80211 phy0: U iwl_init_channel_map Ch. 13 Flags 0
[2.4GHz] - No traffic
[    4.252163] ieee80211 phy0: U iwl_init_channel_map Ch. 14 Flags 0
[2.4GHz] - No traffic
[    4.252165] ieee80211 phy0: U iwl_init_channel_map Ch. 183 Flags 0
[5.2GHz] - No traffic
[    4.252168] ieee80211 phy0: U iwl_init_channel_map Ch. 184 Flags 0
[5.2GHz] - No traffic
[    4.252170] ieee80211 phy0: U iwl_init_channel_map Ch. 185 Flags 0
[5.2GHz] - No traffic
[    4.252173] ieee80211 phy0: U iwl_init_channel_map Ch. 187 Flags 0
[5.2GHz] - No traffic
[    4.252175] ieee80211 phy0: U iwl_init_channel_map Ch. 188 Flags 0
[5.2GHz] - No traffic
[    4.252178] ieee80211 phy0: U iwl_init_channel_map Ch. 189 Flags 0
[5.2GHz] - No traffic
[    4.252180] ieee80211 phy0: U iwl_init_channel_map Ch. 192 Flags 0
[5.2GHz] - No traffic
[    4.252183] ieee80211 phy0: U iwl_init_channel_map Ch. 196 Flags 0
[5.2GHz] - No traffic
[    4.252186] ieee80211 phy0: U iwl_init_channel_map Ch. 7 Flags 0
[5.2GHz] - No traffic
[    4.252188] ieee80211 phy0: U iwl_init_channel_map Ch. 8 Flags 0
[5.2GHz] - No traffic
[    4.252191] ieee80211 phy0: U iwl_init_channel_map Ch. 11 Flags 0
[5.2GHz] - No traffic
[    4.252193] ieee80211 phy0: U iwl_init_channel_map Ch. 12 Flags 0
[5.2GHz] - No traffic
[    4.252196] ieee80211 phy0: U iwl_init_channel_map Ch. 16 Flags 0
[5.2GHz] - No traffic
[    4.252198] ieee80211 phy0: U iwl_init_channel_map Ch. 34 Flags 0
[5.2GHz] - No traffic
[    4.252201] ieee80211 phy0: U iwl_init_channel_map Ch. 36 [5.2GHz]
VALID WIDE (0x21 15dBm): Ad-Hoc not supported
[    4.252204] ieee80211 phy0: U iwl_init_channel_map Ch. 38 Flags 0
[5.2GHz] - No traffic
[    4.252207] ieee80211 phy0: U iwl_init_channel_map Ch. 40 [5.2GHz]
VALID WIDE (0x21 15dBm): Ad-Hoc not supported
[    4.252210] ieee80211 phy0: U iwl_init_channel_map Ch. 42 Flags 0
[5.2GHz] - No traffic
[    4.252214] ieee80211 phy0: U iwl_init_channel_map Ch. 44 [5.2GHz]
VALID WIDE (0x21 15dBm): Ad-Hoc not supported
[    4.252216] ieee80211 phy0: U iwl_init_channel_map Ch. 46 Flags 0
[5.2GHz] - No traffic
[    4.252220] ieee80211 phy0: U iwl_init_channel_map Ch. 48 [5.2GHz]
VALID WIDE (0x21 15dBm): Ad-Hoc not supported
[    4.252224] ieee80211 phy0: U iwl_init_channel_map Ch. 52 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    4.252227] ieee80211 phy0: U iwl_init_channel_map Ch. 56 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    4.252231] ieee80211 phy0: U iwl_init_channel_map Ch. 60 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    4.252234] ieee80211 phy0: U iwl_init_channel_map Ch. 64 [5.2GHz]
VALID RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    4.252243] ieee80211 phy0: U iwl_init_channel_map Ch. 100 Flags 0
[5.2GHz] - No traffic
[    4.252245] ieee80211 phy0: U iwl_init_channel_map Ch. 104 Flags 0
[5.2GHz] - No traffic
[    4.252247] ieee80211 phy0: U iwl_init_channel_map Ch. 108 Flags 0
[5.2GHz] - No traffic
[    4.252249] ieee80211 phy0: U iwl_init_channel_map Ch. 112 Flags 0
[5.2GHz] - No traffic
[    4.252252] ieee80211 phy0: U iwl_init_channel_map Ch. 116 Flags 0
[5.2GHz] - No traffic
[    4.252254] ieee80211 phy0: U iwl_init_channel_map Ch. 120 Flags 0
[5.2GHz] - No traffic
[    4.252256] ieee80211 phy0: U iwl_init_channel_map Ch. 124 Flags 0
[5.2GHz] - No traffic
[    4.252258] ieee80211 phy0: U iwl_init_channel_map Ch. 128 Flags 0
[5.2GHz] - No traffic
[    4.252274] ieee80211 phy0: U iwl_init_channel_map Ch. 132 Flags 0
[5.2GHz] - No traffic
[    4.252276] ieee80211 phy0: U iwl_init_channel_map Ch. 136 Flags 0
[5.2GHz] - No traffic
[    4.252278] ieee80211 phy0: U iwl_init_channel_map Ch. 140 Flags 0
[5.2GHz] - No traffic
[    4.252281] ieee80211 phy0: U iwl_init_channel_map Ch. 145 Flags 0
[5.2GHz] - No traffic
[    4.252284] ieee80211 phy0: U iwl_init_channel_map Ch. 149 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252287] ieee80211 phy0: U iwl_init_channel_map Ch. 153 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252290] ieee80211 phy0: U iwl_init_channel_map Ch. 157 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252293] ieee80211 phy0: U iwl_init_channel_map Ch. 161 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252297] ieee80211 phy0: U iwl_init_channel_map Ch. 165 [5.2GHz]
VALID WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252300] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 1
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252303] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 5
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252306] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 2
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252309] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 6
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252312] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 3
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252315] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 7
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252318] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 4
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252321] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 8
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252324] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 5
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252327] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 9
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252330] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 6
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252333] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 10
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252336] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 7
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252339] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 11
[2.4GHz] (0x00 0dBm): Ad-Hoc not supported
[    4.252342] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 36
[5.2GHz] WIDE (0x21 13dBm): Ad-Hoc not supported
[    4.252346] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 40
[5.2GHz] WIDE (0x21 13dBm): Ad-Hoc not supported
[    4.252349] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 44
[5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[    4.252352] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 48
[5.2GHz] WIDE (0x21 15dBm): Ad-Hoc not supported
[    4.252355] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 52
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    4.252359] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 56
[5.2GHz] RADAR WIDE (0x31 15dBm): Ad-Hoc not supported
[    4.252362] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 60
[5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[    4.252365] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 64
[5.2GHz] RADAR WIDE (0x31 14dBm): Ad-Hoc not supported
[    4.252369] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 149
[5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252372] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 153
[5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252375] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 157
[5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252379] ieee80211 phy0: U iwl_set_fat_chan_info FAT Ch. 161
[5.2GHz] WIDE (0x21 16dBm): Ad-Hoc not supported
[    4.252383] ieee80211 phy0: U iwlcore_init_geos Channel 1
Freq=2412[2.4GHz] valid flag=0x20
[    4.252386] ieee80211 phy0: U iwlcore_init_geos Channel 2
Freq=2417[2.4GHz] valid flag=0x20
[    4.252388] ieee80211 phy0: U iwlcore_init_geos Channel 3
Freq=2422[2.4GHz] valid flag=0x20
[    4.252391] ieee80211 phy0: U iwlcore_init_geos Channel 4
Freq=2427[2.4GHz] valid flag=0x20
[    4.252394] ieee80211 phy0: U iwlcore_init_geos Channel 5
Freq=2432[2.4GHz] valid flag=0x0
[    4.252396] ieee80211 phy0: U iwlcore_init_geos Channel 6
Freq=2437[2.4GHz] valid flag=0x0
[    4.252399] ieee80211 phy0: U iwlcore_init_geos Channel 7
Freq=2442[2.4GHz] valid flag=0x0
[    4.252401] ieee80211 phy0: U iwlcore_init_geos Channel 8
Freq=2447[2.4GHz] valid flag=0x10
[    4.252404] ieee80211 phy0: U iwlcore_init_geos Channel 9
Freq=2452[2.4GHz] valid flag=0x10
[    4.252406] ieee80211 phy0: U iwlcore_init_geos Channel 10
Freq=2457[2.4GHz] valid flag=0x10
[    4.252409] ieee80211 phy0: U iwlcore_init_geos Channel 11
Freq=2462[2.4GHz] valid flag=0x10
[    4.252412] ieee80211 phy0: U iwlcore_init_geos Channel 36
Freq=5180[5.2GHz] valid flag=0x26
[    4.252415] ieee80211 phy0: U iwlcore_init_geos Channel 40
Freq=5200[5.2GHz] valid flag=0x16
[    4.252417] ieee80211 phy0: U iwlcore_init_geos Channel 44
Freq=5220[5.2GHz] valid flag=0x26
[    4.252420] ieee80211 phy0: U iwlcore_init_geos Channel 48
Freq=5240[5.2GHz] valid flag=0x16
[    4.252422] ieee80211 phy0: U iwlcore_init_geos Channel 52
Freq=5260[5.2GHz] valid flag=0x2E
[    4.252425] ieee80211 phy0: U iwlcore_init_geos Channel 56
Freq=5280[5.2GHz] valid flag=0x1E
[    4.252428] ieee80211 phy0: U iwlcore_init_geos Channel 60
Freq=5300[5.2GHz] valid flag=0x2E
[    4.252430] ieee80211 phy0: U iwlcore_init_geos Channel 64
Freq=5320[5.2GHz] valid flag=0x1E
[    4.252433] ieee80211 phy0: U iwlcore_init_geos Channel 149
Freq=5745[5.2GHz] valid flag=0x26
[    4.252435] ieee80211 phy0: U iwlcore_init_geos Channel 153
Freq=5765[5.2GHz] valid flag=0x16
[    4.252438] ieee80211 phy0: U iwlcore_init_geos Channel 157
Freq=5785[5.2GHz] valid flag=0x26
[    4.252441] ieee80211 phy0: U iwlcore_init_geos Channel 161
Freq=5805[5.2GHz] valid flag=0x16
[    4.252443] ieee80211 phy0: U iwlcore_init_geos Channel 165
Freq=5825[5.2GHz] valid flag=0x36
[    4.252445] iwlagn 0000:03:00.0: Tunable channels: 11 802.11bg, 13
802.11a channels
[    4.252556] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
[    4.252945] iwlagn 0000:03:00.0: Failed to register hw (error -17)
[    4.253255] iwlagn 0000:03:00.0: PCI INT A disabled
[    4.253263] iwlagn: probe of 0000:03:00.0 failed with error -17
