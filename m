Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60171 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1D3OAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 10:00:39 -0400
Received: by bwz15 with SMTP id 15so3705870bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Apr 2011 07:00:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Steffen Jost <steffenjost@web.de>
Subject: Re: carl9170 WLAN USB frequently drops, dmesg attached
Date: Sat, 30 Apr 2011 16:00:31 +0200
Cc: linux-wireless@vger.kernel.org
References: <4DBC139F.9020206@web.de>
In-Reply-To: <4DBC139F.9020206@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201104301600.32046.chunkeey@googlemail.com> (sfid-20110430_160053_999019_098AEA31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On Saturday 30 April 2011 15:50:23 Steffen Jost wrote:
> I was advised by lwfinger on the opensuse-forums to send the attached 
> dmesg output to this email address.
> 
> The dmesg.out was taken after: booting, then using the USB WLAN Stick to 
> browse the net, which caused the connection to drop, networkmanager 
> reconnecting, browsing, dropping again and eventually connecting the 
> machine to the net by Ethernet via a WLAN-Bridge device.

[    9.916283] usbcore: registered new interface driver ar9170usb
[   10.177059] usb 1-2: ar9170.fw firmware file not found, trying old firmware...
[   11.130602] ath: EEPROM regdomain: 0x809c
[   11.130623] ath: Country alpha2 being used: CN
[   11.258624] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   11.264370] Registered led device: ar9170-phy0::tx
[   11.264429] Registered led device: ar9170-phy0::assoc
[   11.264437] usb 1-2: Atheros AR9170 is registered as 'phy0'

looks like ar9170usb to me... can you please attach a dmesg with carl9170?

Regards,
	Christian
