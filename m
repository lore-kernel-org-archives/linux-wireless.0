Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:46576 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3FVXsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jun 2013 19:48:06 -0400
Received: by mail-wg0-f41.google.com with SMTP id y10so1527291wgg.2
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jun 2013 16:48:04 -0700 (PDT)
Received: from localhost (42.121.220.87.dynamic.jazztel.es. [87.220.121.42])
        by mx.google.com with ESMTPSA id b20sm6967220wiw.4.2013.06.22.16.48.02
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sat, 22 Jun 2013 16:48:03 -0700 (PDT)
Message-ID: <51C637B2.8090000@gmail.com> (sfid-20130623_014826_838300_75708F6A)
Date: Sun, 23 Jun 2013 01:48:02 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: rtlwifi rtl8192cu: unable to use channels 12 and 13 in Europe
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

kernel 3.9.7-100.fc17.x86_64

- dmesg:

usb 2-1.5: new high-speed USB device number 16 using ehci-pci
usb 2-1.5: New USB device found, idVendor=0bda, idProduct=8176
usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.5: Product: 802.11n WLAN Adapter
usb 2-1.5: Manufacturer: Realtek
usb 2-1.5: SerialNumber: 00e04c000001
rtl8192cu: Chip version 0x10
rtl8192cu: MAC address: 00:e0:4c:07:dd:45
rtl8192cu: Board Type 0
rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
ieee80211 phy11: Selected rate control algorithm 'rtl_rc'
rtlwifi: wireless switch is on
cfg80211: Calling CRDA for country: ES
cfg80211: Regulatory domain changed to country: ES
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
rtl8192cu: MAC auto ON okay!
rtl8192cu: Tx queue select: 0x05
IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready


- iw list:

Wiphy phy2
        Band 1:
                Capabilities: 0x1862
                        HT20/HT40
                        Static SM Power Save
                        RX HT20 SGI
                        RX HT40 SGI
                        No RX STBC
                        Max AMSDU length: 7935 bytes
                        DSSS/CCK HT40
                Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
                Minimum RX AMPDU time spacing: 16 usec (0x07)
                HT TX/RX MCS rate indexes supported: 0-7, 32
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
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps
                        * 5.5 Mbps
                        * 11.0 Mbps
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 4
        max scan IEs length: 2257 bytes
        RTS threshold: 2347
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
                 * AP
                 * AP/VLAN
                 * monitor
        software interface modes (can always be added):
                 * AP/VLAN
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
                 * set_tx_bitrate_mask
                 * action
                 * frame_wait_cancel
                 * set_wiphy_netns
                 * set_channel
                 * set_wds_peer
                 * Unknown command (84)
                 * Unknown command (87)
                 * Unknown command (85)
                 * Unknown command (89)
                 * Unknown command (92)
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * managed: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * AP/VLAN: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * mesh point: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * P2P-client: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * P2P-GO: 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
                 * Unknown mode (10): 0x0000 0x0010 0x0020 0x0030 0x0040 0x0050 0x0060 0x0070 0x0080 0x0090 0x00a0 0x00b0 0x00c0 0x00d0 0x00e0 0x00f0
        Supported RX frame types:
                 * IBSS: 0x0040 0x00b0 0x00c0 0x00d0
                 * managed: 0x0040 0x00d0
                 * AP: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * AP/VLAN: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * mesh point: 0x00b0 0x00c0 0x00d0
                 * P2P-client: 0x0040 0x00d0
                 * P2P-GO: 0x0000 0x0020 0x0040 0x00a0 0x00b0 0x00c0 0x00d0
                 * Unknown mode (10): 0x0040 0x00d0
        HT Capability overrides:
                 * MCS: ff ff ff ff ff ff ff ff ff ff
                 * maximum A-MSDU length
                 * supported channel width
                 * short GI for 40 MHz
                 * max A-MPDU length exponent
                 * min MPDU start spacing
        Device supports TX status socket option.
        Device supports HT-IBSS.


thank you.
