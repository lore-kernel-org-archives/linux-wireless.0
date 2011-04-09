Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49605 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1DIDDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 23:03:18 -0400
Received: by qyk7 with SMTP id 7so237197qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 20:03:17 -0700 (PDT)
Message-ID: <4D9FCC70.1020805@gmail.com>
Date: Fri, 08 Apr 2011 23:03:12 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: ath9k_htc oddity
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been using the ethool -i output a lot recently and have been very 
much enjoying it, however I've noticed some oddity.  My ath9k_htc card, 
Ubiquiti Wifistation-EXT, doesn't have good output while using 
compat-wireless stable 2.6.39-rc1.

flea scripts # ethtool -i wlan15
driver: usb
version: 2.6.37-pentoo-r6-grsec
firmware-version: N/A
bus-info: 2-5


Not only is the driver listed incorrectly, but the firmware-version is 
not listed at all. Is it just me?


[  861.541279] usb 2-5: new high speed USB device using ehci_hcd and 
address 6
[  861.976633] usb 2-5: ath9k_htc: Transferred FW: ar9271.fw, size: 51312
[  862.244517] usb 2-5: ath9k_htc: HTC initialized with 33 credits
[  862.661693] ath: EEPROM regdomain: 0x0
[  862.661698] ath: EEPROM indicates default country code should be used
[  862.661701] ath: doing EEPROM country->regdmn map search
[  862.661705] ath: country maps to regdmn code: 0x3a
[  862.661708] ath: Country alpha2 being used: US
[  862.661711] ath: Regpair used: 0x3a
...removed cfg80211 regdomain stuff...
[  862.663179] ieee80211 phy3: Atheros AR9271 Rev:1
[  862.664976] Registered led device: ath9k-phy3::radio
[  862.664999] Registered led device: ath9k-phy3::assoc
[  862.665141] Registered led device: ath9k-phy3::tx
[  862.665163] Registered led device: ath9k-phy3::rx
[  862.665166] usb 2-5: ath9k_htc: USB layer initialized


Thanks,
Rick Farina
