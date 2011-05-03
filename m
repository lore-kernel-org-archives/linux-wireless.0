Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:55903 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1ECSNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 14:13:33 -0400
Received: from [195.4.92.21] (helo=11.mx.freenet.de)
	by mout3.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.72 #5)
	id 1QHK6F-0000oT-9l
	for linux-wireless@vger.kernel.org; Tue, 03 May 2011 20:13:31 +0200
Received: from p54a19618.dip0.t-ipconnect.de ([84.161.150.24]:58802 helo=mail.maya.org)
	by 11.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #3)
	id 1QHK6E-0001uT-TR
	for linux-wireless@vger.kernel.org; Tue, 03 May 2011 20:13:31 +0200
Message-ID: <4DC04643.8040907@01019freenet.de> (sfid-20110503_201337_244157_72FC4A29)
Date: Tue, 03 May 2011 20:15:31 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com
CC: linux-wireless@vger.kernel.org
Subject: rt2800pci died: phy0 -> rt2800pci_txdone: Warning - Got TX status
 for an empty queue 0, dropping
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

the wlan device Linksys WMP600N has been death (= no more data stream
was possible) after these entries in messages:


May  3 17:33:26 dualc kernel: [ 4064.388420] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.388769] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.390368] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.392046] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.393370] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.435730] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.435995] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.437229] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.437476] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.439599] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.474643] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.475113] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.477250] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.555227] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.555655] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.599568] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.641286] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.641594] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.642129] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.642453] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.645940] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.652828] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.973920] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.974368] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.977116] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.977279] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.983693] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.984475] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.985062] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.985606] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.985837] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4064.991119] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4065.004217] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:26 dualc kernel: [ 4065.004654] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.005446] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.009279] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.010002] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.011270] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.011428] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.051152] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.074961] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.115557] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.441969] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.442402] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.443705] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.487983] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:27 dualc kernel: [ 4065.488452] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:28 dualc kernel: [ 4066.293611] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:28 dualc kernel: [ 4066.295894] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:28 dualc kernel: [ 4066.299441] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping
May  3 17:33:28 dualc kernel: [ 4066.312325] phy0 -> rt2800pci_txdone:
Warning - Got TX status for an empty queue 0, dropping


The wlan device is a PCI device and is used as AP and has the following
capabilities:

03:07.0 Network controller: RaLink RT2800 802.11n PCI
        Subsystem: Linksys Device 0067
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (500ns min, 1000ns max), Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fdce0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: rt2800pci


I'm using the actual firmware from Ralink from the git-repository with
linux 2.6.34.9 from OpenSuSE and compat-wireless-v2.6.39-rc1-3.



Wiphy phy0
        Band 1:
                HT capabilities: 0x02f2
                        * 20/40 MHz operation
                        * static SM PS
                        * HT-greenfield
                        * 20 MHz short GI
                        * 40 MHz short GI
                        * TX STBC
                        * RX STBC 2 streams
                        * max A-MSDU len 3839
                HT A-MPDU factor: 0x0003 (65535 bytes)
                HT A-MPDU density: 0x0004 (2 usec)
                HT MCS set: ff ff 00 00 01 00 00 00 00 00 00 00 07 00 00 00
                HT RX MCS rate indexes supported:
                        MCS index 0
                        MCS index 1
                        MCS index 2
                        MCS index 3
                        MCS index 4
                        MCS index 5
                        MCS index 6
                        MCS index 7
                        MCS index 8
                        MCS index 9
                        MCS index 10
                        MCS index 11
                        MCS index 12
                        MCS index 13
                        MCS index 14
                        MCS index 15
                        MCS index 32
TX unequal modulation not supported
                HT TX Max spatiel streams: 32
                HT TX MCS rate indexes supported may differ
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)
                        * 2427 MHz [4] (20.0 dBm)
                        * 2432 MHz [5] (20.0 dBm)
                        * 2437 MHz [6] (20.0 dBm)
                        * 2442 MHz [7] (20.0 dBm)
                        * 2447 MHz [8] (20.0 dBm)
                        * 2452 MHz [9] (20.0 dBm)
                        * 2457 MHz [10] (20.0 dBm)
                        * 2462 MHz [11] (20.0 dBm)
                        * 2467 MHz [12] (20.0 dBm)
                        * 2472 MHz [13] (20.0 dBm)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Band 2:
                HT capabilities: 0x02f2
                        * 20/40 MHz operation
                        * static SM PS
                        * HT-greenfield
                        * 20 MHz short GI
                        * 40 MHz short GI
                        * TX STBC
                        * RX STBC 2 streams
                        * max A-MSDU len 3839
                HT A-MPDU factor: 0x0003 (65535 bytes)
                HT A-MPDU density: 0x0004 (2 usec)
                HT MCS set: ff ff 00 00 01 00 00 00 00 00 00 00 07 00 00 00
                HT RX MCS rate indexes supported:
                        MCS index 0
                        MCS index 1
                        MCS index 2
                        MCS index 3
                        MCS index 4
                        MCS index 5
                        MCS index 6
                        MCS index 7
                        MCS index 8
                        MCS index 9
                        MCS index 10
                        MCS index 11
                        MCS index 12
                        MCS index 13
                        MCS index 14
                        MCS index 15
                        MCS index 32
TX unequal modulation not supported
                HT TX Max spatiel streams: 32
                HT TX MCS rate indexes supported may differ
                Frequencies:
                        * 5180 MHz [36] (20.0 dBm) (radar detection)
                        * 5190 MHz [38] (20.0 dBm) (radar detection)
                        * 5200 MHz [40] (20.0 dBm) (radar detection)
                        * 5220 MHz [44] (20.0 dBm) (radar detection)
                        * 5230 MHz [46] (20.0 dBm) (radar detection)
                        * 5240 MHz [48] (20.0 dBm) (radar detection)
                        * 5260 MHz [52] (20.0 dBm) (radar detection)
                        * 5270 MHz [54] (20.0 dBm) (radar detection)
                        * 5280 MHz [56] (20.0 dBm) (radar detection)
                        * 5300 MHz [60] (20.0 dBm) (radar detection)
                        * 5310 MHz [62] (20.0 dBm) (radar detection)
                        * 5320 MHz [64] (20.0 dBm) (radar detection)
                        * 5500 MHz [100] (26.0 dBm) (radar detection)
                        * 5510 MHz [102] (26.0 dBm) (radar detection)
                        * 5520 MHz [104] (26.0 dBm) (radar detection)
                        * 5540 MHz [108] (26.0 dBm) (radar detection)
                        * 5550 MHz [110] (26.0 dBm) (radar detection)
                        * 5560 MHz [112] (26.0 dBm) (radar detection)
                        * 5580 MHz [116] (26.0 dBm) (radar detection)
                        * 5590 MHz [118] (26.0 dBm) (radar detection)
                        * 5600 MHz [120] (26.0 dBm) (radar detection)
                        * 5620 MHz [124] (26.0 dBm) (radar detection)
                        * 5630 MHz [126] (26.0 dBm) (radar detection)
                        * 5640 MHz [128] (26.0 dBm) (radar detection)
                        * 5660 MHz [132] (26.0 dBm) (radar detection)
                        * 5670 MHz [134] (26.0 dBm) (radar detection)
                        * 5680 MHz [136] (26.0 dBm) (radar detection)
                        * 5700 MHz [140] (26.0 dBm) (radar detection)
                        * 5745 MHz [149] (disabled)
                        * 5755 MHz [151] (disabled)
                        * 5765 MHz [153] (disabled)
                        * 5785 MHz [157] (disabled)
                        * 5795 MHz [159] (disabled)
                        * 5805 MHz [161] (disabled)
                        * 5825 MHz [165] (disabled)
                        * 5835 MHz [167] (disabled)
                        * 5845 MHz [169] (disabled)
                        * 5855 MHz [171] (disabled)
                        * 5865 MHz [173] (disabled)
                        * 4920 MHz [-16] (disabled)
                        * 4940 MHz [-12] (disabled)
                        * 4960 MHz [-8] (disabled)
                        * 4980 MHz [-4] (disabled)
                        * 6040 MHz [208] (disabled)
                        * 6060 MHz [212] (disabled)
                        * 6080 MHz [216] (disabled)
                Bitrates (non-HT):
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * WDS
                 * monitor
                 * mesh point


Loading the driver and starting hostapd gives the following log entries
in messages:


May  3 19:49:03 dualc kernel: [  155.624738] Compat-wireless backport
release: compat-wireless-v2.6.39-rc1-3
May  3 19:49:03 dualc kernel: [  155.624742] Backport based on
linux-2.6-allstable.git v2.6.39-rc1
May  3 19:49:03 dualc kernel: [  155.712856] cfg80211: Calling CRDA to
update world regulatory domain
May  3 19:49:03 dualc kernel: [  155.789124] cfg80211: World regulatory
domain updated:
May  3 19:49:03 dualc kernel: [  155.789128] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May  3 19:49:03 dualc kernel: [  155.789131] cfg80211:     (2402000 KHz
- 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May  3 19:49:03 dualc kernel: [  155.789133] cfg80211:     (2457000 KHz
- 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May  3 19:49:03 dualc kernel: [  155.789135] cfg80211:     (2474000 KHz
- 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
May  3 19:49:03 dualc kernel: [  155.789138] cfg80211:     (5170000 KHz
- 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May  3 19:49:03 dualc kernel: [  155.789140] cfg80211:     (5735000 KHz
- 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
May  3 19:49:03 dualc kernel: [  155.850106]   alloc irq_desc for 21 on
node 0
May  3 19:49:03 dualc kernel: [  155.850109]   alloc kstat_irqs on node 0
May  3 19:49:03 dualc kernel: [  155.850121] rt2800pci 0000:03:07.0: PCI
INT A -> GSI 21 (level, low) -> IRQ 21
May  3 19:49:03 dualc kernel: [  155.863254] phy0 -> rt2x00_set_chip:
Info - Chipset detected - rt: 2860, rf: 0002, rev: 0103.
May  3 19:49:03 dualc kernel: [  155.881232] ieee80211 phy0: Selected
rate control algorithm 'minstrel_ht'
May  3 19:49:03 dualc kernel: [  155.882070] Registered led device:
rt2800pci-phy0::radio
May  3 19:49:03 dualc kernel: [  155.882087] Registered led device:
rt2800pci-phy0::assoc
May  3 19:49:03 dualc kernel: [  155.882104] Registered led device:
rt2800pci-phy0::quality
May  3 19:49:03 dualc kernel: [  155.889962] wlan0 renamed to wlan1 by
udevd [4520]
May  3 19:49:03 dualc kernel: [  155.892084] udev: renamed network
interface wlan0 to wlan1
May  3 19:49:03 dualc ifup:     wlan1     device: RaLink RT2800 802.11n PCI
May  3 19:49:03 dualc ifup:               No configuration found for wlan1
May  3 19:49:11 dualc sudo:  andreas : TTY=unknown ;
PWD=/raid/home/andreas/Documents ; USER=andreas_n ;
COMMAND=/usr/bin/start-seamonkey
May  3 19:49:34 dualc kernel: [  186.225308] phy0 ->
rt2x00lib_request_firmware: Info - Loading firmware file 'rt2860.bin'.
May  3 19:49:34 dualc kernel: [  186.225324] rt2800pci 0000:03:07.0:
firmware: requesting rt2860.bin
May  3 19:49:34 dualc kernel: [  186.277145] phy0 ->
rt2x00lib_request_firmware: Info - Firmware detected - version: 0.34.
May  3 19:49:34 dualc kernel: [  186.304666] phy0 ->
rt2800pci_mcu_status: Error - MCU request failed, no response from hardware
May  3 19:49:34 dualc kernel: [  186.311332] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
May  3 19:49:34 dualc kernel: [  186.311345] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
May  3 19:49:34 dualc kernel: [  186.311358] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
May  3 19:49:34 dualc kernel: [  186.311369] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
May  3 19:49:34 dualc ifup:     mon.wlan1 device: RaLink RT2800 802.11n PCI

May  3 19:49:34 dualc ifup:               No configuration found for
mon.wlan1
May  3 19:49:34 dualc kernel: [  186.362289] NET: Registered protocol
family 17
May  3 19:49:34 dualc kernel: [  186.364258] device wlan1 entered
promiscuous mode
May  3 19:49:34 dualc kernel: [  186.365501] br0: port 5(wlan1) entering
forwarding state
May  3 19:49:34 dualc kernel: [  186.366185] cfg80211: Calling CRDA for
country: DE
May  3 19:49:34 dualc kernel: [  186.368829] cfg80211: Regulatory domain
changed to country: DE
May  3 19:49:34 dualc kernel: [  186.368832] cfg80211:     (start_freq -
end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May  3 19:49:34 dualc kernel: [  186.368835] cfg80211:     (2400000 KHz
- 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
May  3 19:49:34 dualc kernel: [  186.368837] cfg80211:     (5150000 KHz
- 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
May  3 19:49:34 dualc kernel: [  186.368839] cfg80211:     (5470000 KHz
- 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
May  3 19:49:36 dualc avahi-daemon[4538]: Registering new address record
for fe80::6a7f:74ff:fefb:39ee on wlan1.*.
May  3 19:49:37 dualc hostapd: wlan1: RADIUS Authentication server
192.168.1.228:1812
May  3 19:49:37 dualc hostapd: wlan1: RADIUS Accounting server
192.168.1.228:1813
May  3 19:49:37 dualc kernel: [  189.882578] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 0 - CWmin: 2, CWmax: 3, Aifs: 1, TXop: 47.
May  3 19:49:37 dualc kernel: [  189.882662] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 1 - CWmin: 3, CWmax: 4, Aifs: 1, TXop: 94.
May  3 19:49:37 dualc kernel: [  189.882712] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 2 - CWmin: 4, CWmax: 6, Aifs: 3, TXop: 0.
May  3 19:49:37 dualc kernel: [  189.882763] phy0 -> rt2x00mac_conf_tx:
Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 7, TXop: 0.



Could you please fix this bug?
Thank you,
Andreas
