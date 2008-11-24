Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n3a.bullet.mail.ac4.yahoo.com ([76.13.13.66]:33276 "HELO
	n3a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754249AbYKXRlf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 12:41:35 -0500
Date: Mon, 24 Nov 2008 09:41:34 -0800 (PST)
From: Irwan Siajadi <dev.bahamot@yahoo.com>
Subject: ath5k: can't browse at all.
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <978525.69086.qm@web59613.mail.ac4.yahoo.com> (sfid-20081124_184147_491407_AB87D95E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR2425 is able to obtain IP address from the router, 
able to ping with good results, but can't browse at all.
Below are the info on my setup, if you need more info please let me know.

Driver version: compat-wireless-2008-11-24.tar.bz2.
Kernel: 2.6.27.4-2mnbcustom (mandriva), compiled with mandriva provided 
..config but without any WLAN support except WIRELESS_EXT.
Access point/router is configured to use channel 1 (2.412GHz).

dmesg:
"...
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: JP
          (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
          (2402000 KHz - 2494000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
          (5160000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
          (5250000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
cfg80211: Calling CRDA for country: JP
.....
ath5k 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath5k 0000:05:00.0: setting latency timer to 64
ath5k 0000:05:00.0: registered as 'phy0'
phy0: Selected rate control algorithm 'minstrel'
ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
.....
wlan0: authenticate with AP 00:04:ed:42:60:67
wlan0: authenticated
wlan0: associate with AP 00:04:ed:42:60:67
wlan0: RX AssocResp from 00:04:ed:42:60:67 (capab=3D0x431 status=3D0 id=3D)
wlan0: associated
....."

lspci:
"05:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg 
Wireless PCI Express Adapter (rev 01)
          Subsystem: Device 1a3b:1026
          Flags: bus master, fast devsel, latency 0, IRQ 16
          Memory at feaf0000 (64-bit, non-prefetchable) [size=3D64K]
          Capabilities: [40] Power Management version 2
          Capabilities: [50] Message Signalled Interrupts: Mask- 64bit Queue=3D0/0 Enable-
          Capabilities: [60] Express Legacy Endpoint, MSI 00
          Capabilities: [90] MSI-X: Enable- Mask- TabSize=3D1
          Capabilities: [100] Advanced Error Reporting <?>
          Capabilities: [140] Virtual Channel <?>"

TIA,
Irwan.


      

