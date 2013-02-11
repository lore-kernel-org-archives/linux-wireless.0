Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:33058 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932710Ab3BKV45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:56:57 -0500
Received: by mail-we0-f180.google.com with SMTP id k14so5113316wer.39
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2013 13:56:56 -0800 (PST)
Message-ID: <51196925.1050503@gmail.com> (sfid-20130211_225700_616459_32094102)
Date: Mon, 11 Feb 2013 22:56:53 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rt2800usb_txdone_entry_check: Warning - TX status report missed
 for queue XX entry ZZ
References: <5119664D.9030902@gmail.com>
In-Reply-To: <5119664D.9030902@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 10:44 PM, Xose Vazquez Perez wrote:
> hi,
> 
> ( 3.7.6-102.fc17.x86_64 + compat-drivers-3.8-rc7-1 )
> 
> with this device:
> usb 2-1.5: new high-speed USB device number 9 using ehci_hcd
> usb 2-1.5: New USB device found, idVendor=148f, idProduct=5370
> usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-1.5: Product: 802.11 n WLAN
> usb 2-1.5: Manufacturer: Ralink
> usb 2-1.5: SerialNumber: 1.0
> usb 2-1.5: reset high-speed USB device number 9 using ehci_hcd
> phy4 -> rt2x00_set_chip: Info - Chipset detected - rt: 5390, rf: 5370, rev: 0502.
> ieee80211 phy4: Selected rate control algorithm 'minstrel_ht'
> Registered led device: rt2800usb-phy4::radio
> Registered led device: rt2800usb-phy4::assoc
> Registered led device: rt2800usb-phy4::quality
> phy4 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'.
> phy4 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.33.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> phy4 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 4, CWmax: 10, Aifs: 2, TXop: 0.
> 
> and debug enabled, I see a lot of:
> Feb 11 22:34:28 chuchi kernel: [  935.675466] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 7
> Feb 11 22:34:29 chuchi kernel: [  935.745710] phy5 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 11

Also with:
usb 2-1.5: New USB device found, idVendor=148f, idProduct=3070
usb 2-1.5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.5: Product: 802.11 n WLAN
usb 2-1.5: Manufacturer: Ralink
usb 2-1.5: SerialNumber: 1.0
usb 2-1.5: reset high-speed USB device number 13 using ehci_hcd
phy8 -> rt2x00_set_chip: Info - Chipset detected - rt: 3070, rf: 0005, rev: 0201.
