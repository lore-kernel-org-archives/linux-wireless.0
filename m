Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44084 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3ALVgc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 16:36:32 -0500
Received: by mail-wg0-f52.google.com with SMTP id 12so1426958wgh.7
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2013 13:36:31 -0800 (PST)
Message-ID: <50F1D75B.9010105@gmail.com> (sfid-20130112_223640_155823_74C18324)
Date: Sat, 12 Jan 2013 22:36:27 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi/rtl8188ee: Add firmware for new driver
References: <50F03255.4040605@gmail.com> <50F0381A.4010305@lwfinger.net> <50F0AF10.9030200@gmail.com>
In-Reply-To: <50F0AF10.9030200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2013 01:32 AM, Xose Vazquez Perez wrote:
> On 01/11/2013 05:04 PM, Larry Finger wrote:
> 
>> Yes, I know; however, I have not yet had a chance to test those new
>> firmware files yet. As I have had problems in the past with new Realtek
>> firmware, I am now cautious. Have you tested this new firmware?
> 
> No. sorry. Here only one USB realtek device, rtl8192cu.

Larry, could it be possible to print the *firmware version* in the
rtlwifi output ?

It's the only interesting thing missing:

usb 2-1.4: new high-speed USB device number 5 using ehci_hcd
usb 2-1.4: New USB device found, idVendor=0bda, idProduct=8176
usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.4: Product: 802.11n WLAN Adapter
usb 2-1.4: Manufacturer: Realtek
usb 2-1.4: SerialNumber: 00e04c000001
rtl8192cu: Chip version 0x10
rtl8192cu: MAC address: 00:e0:4c:07:dd:45
rtl8192cu: Board Type 0
rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
usbcore: registered new interface driver rtl8192cu
ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
rtlwifi: wireless switch is on
cfg80211: Calling CRDA for country: ES


-thanks-
