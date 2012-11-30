Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:51599 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2K3CVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 21:21:08 -0500
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: ath9k_htc test release: please test
Date: Fri, 30 Nov 2012 03:14:24 +0100
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel" <ath9k-devel@lists.ath9k.org>
References: <CAJ-VmomxqY4FbzRSXtXTgUbVJOSwTJJAF953UO0xN275pPTJLg@mail.gmail.com>
In-Reply-To: <CAJ-VmomxqY4FbzRSXtXTgUbVJOSwTJJAF953UO0xN275pPTJLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201211300314.51331.s.L-H@gmx.de> (sfid-20121130_032113_418870_EB2DE616)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thursday 29 November 2012, Adrian Chadd wrote:
> Hi all,
> 
> I've done an updated build of the ath9k_htc firmware images. I don't
> currently have a HTC setup working so this is just a recompilation of
> the current firmware.
> 
> http://dev.qca.qualcomm.com/~adrian/htc/20121128/
> 
> Please let me know if it works or doesn't work for you.
[…]

Seems to work for me with ar9271/ TP-Link TL-WN721N, I don't notice 
anything strange so far. Feel free to ask me for any specific tests.

Bus 001 Device 003: ID 0cf3:9271 Atheros Communications, Inc. AR9271 802.11n

61a01f78317eff6675f59f6a111846dd */lib/firmware/htc_9271.fw

[   68.843124] usb 1-2: new high-speed USB device number 3 using ehci_hcd
[   68.977959] usb 1-2: New USB device found, idVendor=0cf3, idProduct=9271
[   68.977977] usb 1-2: New USB device strings: Mfr=16, Product=32, SerialNumber=48
[   68.977989] usb 1-2: Product: USB2.0 WLAN
[   68.978000] usb 1-2: Manufacturer: ATHEROS
[   68.978070] usb 1-2: SerialNumber: 12345
[   69.013788] usb 1-2: ath9k_htc: Firmware htc_9271.fw requested
[   69.013873] usbcore: registered new interface driver ath9k_htc
[   69.308128] usb 1-2: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
[   69.543716] ath9k_htc 1-2:1.0: ath9k_htc: HTC initialized with 33 credits
[   69.753110] ath9k_htc 1-2:1.0: ath9k_htc: FW Version: 1.3
[   69.753123] ath: EEPROM regdomain: 0x809c
[   69.753130] ath: EEPROM indicates we should expect a country code
[   69.753138] ath: doing EEPROM country->regdmn map search
[   69.753145] ath: country maps to regdmn code: 0x52
[   69.753153] ath: Country alpha2 being used: CN
[   69.753160] ath: Regpair used: 0x52
[   69.755825] ieee80211 phy1: Atheros AR9271 Rev:1
[   69.756598] cfg80211: Calling CRDA for country: CN
[   69.762598] Registered led device: ath9k_htc-phy1
[   69.784992] cfg80211: Current regulatory domain intersected:
[   69.785376] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   69.785387] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   72.936100] cfg80211: Calling CRDA to update world regulatory domain
[   72.956353] cfg80211: World regulatory domain updated:
[   72.956361] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   72.956368] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   72.956373] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   72.956378] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   72.956383] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   72.956389] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   73.708543] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   74.906125] wlan1: authenticate with <MAC redacted>
[   75.000387] wlan1: send auth to <MAC redacted> (try 1/3)
[   75.002913] wlan1: authenticated
[   75.052045] wlan1: associate with <MAC redacted> (try 1/3)
[   75.055530] wlan1: RX AssocResp from <MAC redacted> (capab=0x411 status=0 aid=1)
[   75.059506] wlan1: associated
[   75.059586] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[   75.059739] cfg80211: Calling CRDA for country: DE
[   75.077662] ath: regdomain 0x8114 updated by CountryIE
[   75.077673] ath: EEPROM regdomain: 0x8114
[   75.077678] ath: EEPROM indicates we should expect a country code
[   75.077683] ath: doing EEPROM country->regdmn map search
[   75.077688] ath: country maps to regdmn code: 0x37
[   75.077693] ath: Country alpha2 being used: DE
[   75.077698] ath: Regpair used: 0x37
[   75.077704] cfg80211: Regulatory domain changed to country: DE
[   75.077710] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   75.077718] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   75.077726] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   75.077732] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   75.077739] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)

The access point is a TP-Link TL-WDR4300 (AR9344+AR9340) running a 
recent OpenWrt build/ ath9k.

By the way, do you happen to know an ar7010+ar9280 dualband/ 2-stream 
device that's a little easier to get hold of than the Netgear WNDA3200 
(UK-only) or the Sony UWA-BR100?

Regards
	Stefan Lippers-Hollmann
