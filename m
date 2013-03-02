Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46582 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3CBJvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 04:51:40 -0500
Received: by mail-wg0-f46.google.com with SMTP id fg15so2995876wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Mar 2013 01:51:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABFmVg5AaTG-F_myEA=WGdYpnwN9X=QfLcjKvwJ1-SUX0quaOg@mail.gmail.com>
References: <CABFmVg5sPub5Q4n+7PnkUn7weQLEUabONeJQZY6aFS2yFZAf2Q@mail.gmail.com>
	<CABFmVg5AaTG-F_myEA=WGdYpnwN9X=QfLcjKvwJ1-SUX0quaOg@mail.gmail.com>
Date: Sat, 2 Mar 2013 11:51:38 +0200
Message-ID: <CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com> (sfid-20130302_105154_574673_1C3954AA)
Subject: Fwd: Intel Wifilink 5100 AGN - Does it support Access Point
 Infrastructure Mode ?
From: Abdelmuhaimen Seaudi <aseaudi@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello iwlwifi support,
I want to run my Wifi Intel WifiLink 5100 AGN in Access Point
Infrstructure Mode, so that I can connect via WiFi with other devices
to my workstation.
This is under Ubuntu Linux 12.10.
I have tried setting the wlan0 to run in master mode, but it gives me
error, as shown below.
Is it possible to run this WiFi radio in AP Infrstrucutre mode ? How ?
Thanks,

aseaudi@Home:~$ iwconfig
wlan0     IEEE 802.11abgn  ESSID:"3Com"
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:22:57:1F:C4:2B
          Bit Rate=48 Mb/s   Tx-Power=15 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=51/70  Signal level=-59 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:468   Missed beacon:0
lo        no wireless extensions.
eth0      no wireless extensions.

aseaudi@Home:~$ sudo iwconfig wlan0 mode master
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

aseaudi@Home:~$ iw list
Wiphy phy0
	Band 1:
		Capabilities: 0x872
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 7935 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT RX MCS rate indexes supported: 0-15, 32
		TX unequal modulation not supported
		HT TX Max spatial streams: 1
		HT TX MCS rate indexes supported may differ
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
			* 2467 MHz [12] (15.0 dBm) (passive scanning, no IBSS)
			* 2472 MHz [13] (15.0 dBm) (passive scanning, no IBSS)
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
		Capabilities: 0x872
			HT20/HT40
			Static SM Power Save
			RX Greenfield
			RX HT20 SGI
			RX HT40 SGI
			No RX STBC
			Max AMSDU length: 7935 bytes
			No DSSS/CCK HT40
		Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
		Minimum RX AMPDU time spacing: 4 usec (0x05)
		HT RX MCS rate indexes supported: 0-15, 32
		TX unequal modulation not supported
		HT TX Max spatial streams: 1
		HT TX MCS rate indexes supported may differ
		Frequencies:
			* 5180 MHz [36] (13.0 dBm) (passive scanning, no IBSS)
			* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)
			* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)
			* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)
			* 5260 MHz [52] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5320 MHz [64] (13.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5500 MHz [100] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5520 MHz [104] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5540 MHz [108] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5560 MHz [112] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5580 MHz [116] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5600 MHz [120] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5620 MHz [124] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5640 MHz [128] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5660 MHz [132] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5680 MHz [136] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5700 MHz [140] (15.0 dBm) (passive scanning, no IBSS, radar detection)
			* 5745 MHz [149] (15.0 dBm) (passive scanning, no IBSS)
			* 5765 MHz [153] (15.0 dBm) (passive scanning, no IBSS)
			* 5785 MHz [157] (15.0 dBm) (passive scanning, no IBSS)
			* 5805 MHz [161] (15.0 dBm) (passive scanning, no IBSS)
			* 5825 MHz [165] (15.0 dBm) (passive scanning, no IBSS)
		Bitrates (non-HT):
			* 6.0 Mbps
			* 9.0 Mbps
			* 12.0 Mbps
			* 18.0 Mbps
			* 24.0 Mbps
			* 36.0 Mbps
			* 48.0 Mbps
			* 54.0 Mbps
	max # scan SSIDs: 20
	max scan IEs length: 195 bytes
	Coverage class: 0 (up to 0m)
	Supported Ciphers:
		* WEP40 (00-0f-ac:1)
		* WEP104 (00-0f-ac:5)
		* TKIP (00-0f-ac:2)
		* CCMP (00-0f-ac:4)
	Available Antennas: TX 0 RX 0
	Supported interface modes:
		 * IBSS
		 * managed
		 * monitor
	software interface modes (can always be added):
		 * monitor
	interface combinations are not supported
	Supported commands:
		 * new_interface
		 * set_interface
		 * new_key
		 * new_beacon
		 * new_station
		 * new_mpath
		 * set_mesh_params
		 * set_bss
		 * authenticate
		 * associate
		 * deauthenticate
		 * disassociate
		 * join_ibss
		 * join_mesh
		 * remain_on_channel
		 * set_tx_bitrate_mask
		 * action
		 * frame_wait_cancel
		 * set_wiphy_netns
		 * set_channel
		 * set_wds_peer
		 * Unknown command (84)
		 * Unknown command (87)
		 * Unknown command (85)
		 * testmode
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
		 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90
0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
		 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0
0xb0 0xc0 0xd0 0xe0 0xf0
	Supported RX frame types:
		 * IBSS: 0xd0
		 * managed: 0x40 0xd0
		 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
		 * mesh point: 0xb0 0xc0 0xd0
		 * P2P-client: 0x40 0xd0
		 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
	Device supports RSN-IBSS.
	HT Capability overrides:
		 * MCS: ff ff ff ff ff ff ff ff ff ff
		 * maximum A-MSDU length
		 * supported channel width
		 * short GI for 40 MHz
		 * max A-MPDU length exponent
		 * min MPDU start spacing
	Device supports TX status socket option.
	Device supports HT-IBSS.
aseaudi@Home:~$

-- 
Thanks and best regards

Abdel-Muhaimen Seaudi
CCIE # 25265
aseaudi@gmail.com
Tel.: +2010-0538-7426



-- 
Thanks and best regards

Abdel-Muhaimen Seaudi
CCIE # 25265
aseaudi@gmail.com
Tel.: +2010-0538-7426



-- 
Thanks and best regards

Abdel-Muhaimen Seaudi
CCIE # 25265
aseaudi@gmail.com
Tel.: +2010-0538-7426
