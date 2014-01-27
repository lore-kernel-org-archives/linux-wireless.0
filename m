Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38382 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaA0IUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 03:20:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1W7hQJ-0005Ll-Py
	for linux-wireless@vger.kernel.org; Mon, 27 Jan 2014 09:20:03 +0100
Received: from 184.77.59.246 ([184.77.59.246])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 09:20:03 +0100
Received: from teknocratdefunct by 184.77.59.246 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 09:20:03 +0100
To: linux-wireless@vger.kernel.org
From: Harvey <teknocratdefunct@riseup.net>
Subject: Centrino Advanced-N 6235 (rev 19) - Microcode Crashing Issues
Date: Mon, 27 Jan 2014 03:14:25 -0500
Message-ID: <lc54gp$6nt$1@ger.gmane.org> (sfid-20140127_092011_422397_51FDE8D6)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hey all, every once and a while my iwlwifi crashes, I'm not sure if this
is the best place for this, but if not please just let me know.
The wifi will work again after a few minutes, but it can be pretty
annoying.. Sometimes its fine, other times wifi is useless..


Kernel is 3.10.25:
Here is the dmesg dump, and more information from iw below, hope that
helps...
This is a laptop with a Intel 6235 Wireless minipcie NIC


[191133.297578] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues Q 2
[191133.297586] iwlwifi 0000:04:00.0: Current SW read_ptr 184 write_ptr 188
[191133.297618] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00  ................
[191133.297636] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x8000309f
[191133.297654] iwlwifi 0000:04:00.0: FH TRBs(1) = 0xc010b004
[191133.297672] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x00000000
[191133.297689] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x80300058
[191133.297707] iwlwifi 0000:04:00.0: FH TRBs(4) = 0x00000000
[191133.297725] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x00000000
[191133.297742] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
[191133.297760] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x0070903b
[191133.297828] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3
ra_tid 0x0000 [89,89]
[191133.297896] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[191133.297964] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1
ra_tid 0x0000 [184,188]
[191133.298032] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0
ra_tid 0x0000 [160,160]
[191133.298099] iwlwifi 0000:04:00.0: Q 4 is active and mapped to fifo 0
ra_tid 0x0000 [0,0]
[191133.298167] iwlwifi 0000:04:00.0: Q 5 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[191133.298235] iwlwifi 0000:04:00.0: Q 6 is active and mapped to fifo 2
ra_tid 0x0000 [0,0]
[191133.298303] iwlwifi 0000:04:00.0: Q 7 is active and mapped to fifo 5
ra_tid 0x0000 [0,0]
[191133.298371] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 4
ra_tid 0x0000 [0,0]
[191133.298439] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7
ra_tid 0x0000 [60,60]
[191133.298521] iwlwifi 0000:04:00.0: Q 10 is active and mapped to fifo
5 ra_tid 0x0000 [0,0]
[191133.298597] iwlwifi 0000:04:00.0: Q 11 is active and mapped to fifo
1 ra_tid 0x0000 [245,183]
[191133.298662] iwlwifi 0000:04:00.0: Q 12 is inactive and mapped to
fifo 0 ra_tid 0x0001 [71,71]
[191133.298729] iwlwifi 0000:04:00.0: Q 13 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[191133.298794] iwlwifi 0000:04:00.0: Q 14 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[191133.298860] iwlwifi 0000:04:00.0: Q 15 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[191133.298926] iwlwifi 0000:04:00.0: Q 16 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[191133.298993] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[191133.299130] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[191133.299216] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to
fifo 0 ra_tid 0x0000 [0,0]
[221414.157751] iwlwifi 0000:04:00.0: Microcode SW error detected.
Restarting 0x2000000.
[221414.157769] iwlwifi 0000:04:00.0: CSR values:
[221414.157772] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
CSR_INT_PERIODIC_REG)
[221414.157778] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG:
0X00484b00
[221414.157784] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING:
0X0000ff40
[221414.157790] iwlwifi 0000:04:00.0:                     CSR_INT:
0X00000000
[221414.157796] iwlwifi 0000:04:00.0:                CSR_INT_MASK:
0X00000000
[221414.157802] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS:
0X00000000
[221414.157807] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN:
0X00000038
[221414.157813] iwlwifi 0000:04:00.0:                   CSR_RESET:
0X00000000
[221414.157819] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL:
0X080403c5
[221414.157824] iwlwifi 0000:04:00.0:                  CSR_HW_REV:
0X000000b0
[221414.157830] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG:
0Xde6e0ffd
[221414.157835] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP:
0X90000801
[221414.157840] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG:
0X00030001
[221414.157846] iwlwifi 0000:04:00.0:                 CSR_GIO_REG:
0X00080044
[221414.157852] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG:
0X00005dbc
[221414.157858] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG:
0X00000000
[221414.157863] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1:
0X00000000
[221414.157869] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2:
0X00000000
[221414.157874] iwlwifi 0000:04:00.0:                 CSR_LED_REG:
0X00000060
[221414.157880] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG:
0X88225ae8
[221414.157886] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS:
0X27800200
[221414.157891] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG:
0X00000000
[221414.157897] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG:
0X0001001a
[221414.157903] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG:
0Xffff0000
[221414.157905] iwlwifi 0000:04:00.0: FH register values:
[221414.157922] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X220a6200
[221414.157938] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X022324f0
[221414.157955] iwlwifi 0000:04:00.0:
FH_RSCSR_CHNL0_WPTR: 0X000000c0
[221414.157971] iwlwifi 0000:04:00.0:
FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80801114
[221414.157988] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[221414.158004] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
[221414.158021] iwlwifi 0000:04:00.0:
FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[221414.158038] iwlwifi 0000:04:00.0:
FH_TSSR_TX_STATUS_REG: 0X07ff0001
[221414.158054] iwlwifi 0000:04:00.0:
FH_TSSR_TX_ERROR_REG: 0X00000000
[221414.158057] iwlwifi 0000:04:00.0: Loaded firmware version: 18.168.6.1
[221414.158202] iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
[221414.158204] iwlwifi 0000:04:00.0: Status: 0x0000004C, count: 6
[221414.158206] iwlwifi 0000:04:00.0: 0x00001041 | ADVANCED_SYSASSERT

[221414.158208] iwlwifi 0000:04:00.0: 0x0001A1EC | uPc
[221414.158210] iwlwifi 0000:04:00.0: 0x0001A098 | branchlink1
[221414.158212] iwlwifi 0000:04:00.0: 0x0001A098 | branchlink2
[221414.158214] iwlwifi 0000:04:00.0: 0x0000DBEA | interruptlink1
[221414.158216] iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
[221414.158217] iwlwifi 0000:04:00.0: 0x000000FE | data1
[221414.158219] iwlwifi 0000:04:00.0: 0x0000001A | data2
[221414.158221] iwlwifi 0000:04:00.0: 0x0000061F | line
[221414.158223] iwlwifi 0000:04:00.0: 0x7A404CA5 | beacon time
[221414.158225] iwlwifi 0000:04:00.0: 0xC8F4E35B | tsf low
[221414.158226] iwlwifi 0000:04:00.0: 0x00000007 | tsf hi
[221414.158228] iwlwifi 0000:04:00.0: 0x00004C93 | time gp1
[221414.158230] iwlwifi 0000:04:00.0: 0x0FB53FC2 | time gp2
[221414.158232] iwlwifi 0000:04:00.0: 0x00000000 | time gp3
[221414.158234] iwlwifi 0000:04:00.0: 0x754312A8 | uCode version
[221414.158235] iwlwifi 0000:04:00.0: 0x000000B0 | hw version
[221414.158237] iwlwifi 0000:04:00.0: 0x00484B00 | board version
[221414.158239] iwlwifi 0000:04:00.0: 0x0250001C | hcmd
[221414.158241] iwlwifi 0000:04:00.0: 0x2FF63002 | isr0
[221414.158243] iwlwifi 0000:04:00.0: 0x11C9E000 | isr1
[221414.158244] iwlwifi 0000:04:00.0: 0x00000F1A | isr2
[221414.158246] iwlwifi 0000:04:00.0: 0x0147FCC2 | isr3
[221414.158248] iwlwifi 0000:04:00.0: 0x00000000 | isr4
[221414.158250] iwlwifi 0000:04:00.0: 0x10004112 | isr_pref
[221414.158251] iwlwifi 0000:04:00.0: 0x0000ECD8 | wait_event
[221414.158253] iwlwifi 0000:04:00.0: 0x00004288 | l2p_control
[221414.158255] iwlwifi 0000:04:00.0: 0x00000024 | l2p_duration
[221414.158257] iwlwifi 0000:04:00.0: 0x000003BF | l2p_mhvalid
[221414.158259] iwlwifi 0000:04:00.0: 0x001054F6 | l2p_addr_match
[221414.158260] iwlwifi 0000:04:00.0: 0x00000005 | lmpm_pmg_sel
[221414.158262] iwlwifi 0000:04:00.0: 0x13011136 | timestamp
[221414.158264] iwlwifi 0000:04:00.0: 0x0000C0D0 | flow_handler
[221414.158337] iwlwifi 0000:04:00.0: Start IWL Event Log Dump: nothing
in log
[221414.158703] ieee80211 phy0: Hardware restart was requested
[221414.158751] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
[221414.165231] iwlwifi 0000:04:00.0: Radio type=0x2-0x1-0x0



 ~ # iw reg get
country US: DFS-UNSET
	(2402 - 2472 @ 40), (3, 27)
	(5170 - 5250 @ 40), (3, 17)
	(5250 - 5330 @ 40), (3, 20), DFS
	(5490 - 5600 @ 40), (3, 20), DFS
	(5650 - 5710 @ 40), (3, 20), DFS
	(5735 - 5835 @ 40), (3, 30)
	(57240 - 63720 @ 2160), (N/A, 40)


 ~ # iw list
Wiphy phy0
	max # scan SSIDs: 20
	max scan IEs length: 195 bytes
	Coverage class: 0 (up to 0m)
	Device supports RSN-IBSS.
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * AP
		 * AP/VLAN
		 * monitor
	Band 1:
		Capabilities: 0x1072
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-15, 32
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
		Frequencies:
			* 2412 MHz [1] (15.0 dBm)
			* 2417 MHz [2] (15.0 dBm)
			* 2422 MHz [3] (15.0 dBm)
			* 2427 MHz [4] (15.0 dBm)
			* 2432 MHz [5] (15.0 dBm)
			* 2437 MHz [6] (15.0 dBm)
			* 2442 MHz [7] (15.0 dBm)
			* 2447 MHz [8] (15.0 dBm)
			* 2452 MHz [9] (15.0 dBm)
			* 2457 MHz [10] (15.0 dBm)
			* 2462 MHz [11] (15.0 dBm)
			* 2467 MHz [12] (disabled)
			* 2472 MHz [13] (disabled)
	Band 2:
		Capabilities: 0x1072
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 3839 bytes
			DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT TX/RX MCS rate indexes supported: 0-15, 32
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
		Frequencies:
			* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5500 MHz [100] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5520 MHz [104] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5540 MHz [108] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5560 MHz [112] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5580 MHz [116] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5600 MHz [120] (disabled)
			* 5620 MHz [124] (disabled)
			* 5640 MHz [128] (disabled)
			* 5660 MHz [132] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5680 MHz [136] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5700 MHz [140] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			  DFS state: usable (for 39310 sec)
			* 5745 MHz [149] (15.0 dBm) (passive scanning, no IBSS)
			* 5765 MHz [153] (15.0 dBm) (passive scanning, no IBSS)
			* 5785 MHz [157] (15.0 dBm) (passive scanning, no IBSS)
			* 5805 MHz [161] (15.0 dBm) (passive scanning, no IBSS)
			* 5825 MHz [165] (15.0 dBm) (passive scanning, no IBSS)
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * start_ap
		 * new_station
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * remain_on_channel
		 * set_tx_bitrate_mask
		 * frame
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * probe_client
		 * set_noack_map
		 * register_beacons
		 * start_p2p_device
		 * Unknown command (92)
		 * connect
		 * disconnect
	Supported TX frame types:
		 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
		 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
		 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
		 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
		 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0
0xc0 0xd0 0xe0 0xf0
		 * P2P-device: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
	Supported RX frame types:
		 * IBSS: 0x40 0xb0 0xc0 0xd0
		 * managed: 0x40 0xd0
		 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * mesh point: 0xb0 0xc0 0xd0
		 * P2P-client: 0x40 0xd0
		 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * P2P-device: 0x40 0xd0
	WoWLAN support:
		 * wake up on disconnect
		 * wake up on magic packet
		 * wake up on pattern match, up to 20 patterns of 16-128 bytes,
		   maximum packet offset 0 bytes
		 * can do GTK rekeying
		 * wake up on GTK rekey failure
		 * wake up on EAP identity request
		 * wake up on rfkill release
	software interface modes (can always be added):
		 * AP/VLAN
		 * monitor
	valid interface combinations:
		 * #{ managed } <= 1, #{ AP } <= 1,
		   total <= 2, #channels <= 1, STA/AP BI must match
		 * #{ managed } <= 2,
		   total <= 2, #channels <= 1
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.
	Device supports scan flush.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS5hVhAAoJEGhkq3NMC00toP0H/0rC1qxbnYthuS/9zlv7/tOQ
YRKlli2/rmT/es5TZmiZJAbaSUx+1JJs09RVF6BbS7LV/UZMBB+2ds4Ui07s2iV9
bQ9q3/1nDyDw+F7uTpreVjWuDcbjQzjlBY6J4InnLxf+yMtOTIwKgpR/DmPEGofD
XHjgW27seX4822XjtdzIKFpwrU12FVk+iBimQyVkUHbFMeag305qrzAZvvrsgFXC
ajMoNsC0giLSm+74q4x3SXzGKU4iyO2s6rxbVRGjdlTpdFXcmYaQT+1AQ+gVbrzX
EHCXMD/3c8JGJj/MeeyJ4578GXft4vhlKTENf9A4R3GHF9mklpn2LQfHios0P8w=
=XpGD
-----END PGP SIGNATURE-----

