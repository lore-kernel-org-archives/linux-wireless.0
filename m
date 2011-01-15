Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57059 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1AOWwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jan 2011 17:52:31 -0500
Received: by gwj20 with SMTP id 20so1535188gwj.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 14:52:30 -0800 (PST)
Message-ID: <4D3223F1.60901@whoplays.asia>
Date: Sun, 16 Jan 2011 07:47:13 +0900
From: "u2@whoplays.asia" <u2@whoplays.asia>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [Driver] NEC WL300NU-G
References: <4D31C1F5.7080306@whoplays.asia> <4D31DBD2.9060909@gmail.com>
In-Reply-To: <4D31DBD2.9060909@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan,

Yes, distribution Debian I use is sometimes old...

I will wait for the 2.6.34~ appears in dist because of maintain-ability.
Thanks for your helpful reply.

Regards,
Miyagi

(2011-01-16 02:39), -------- Message --------:
> On 01/15/11 16:49, u2@whoplays.asia wrote:
>> hi,
>>
>> According to the list linuxwireless.org/en/users/Devices/USB, Wireless USB adapter NEC WL300NU-G[0x409:0x093f] is supported by ar9170usb.
>>
>> But the one I bought via www.amazon.co.jp/NEC-Aterm-WL300NU-G-PA-WL300NU-G is [0x409:0x0249] and not detected by any drivers...
>>
>> $ lsusb
>> Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Bus 002 Device 006: ID 0a5c:2101 Broadcom Corp. Bluetooth Controller
>> Bus 002 Device 005: ID 0853:0100 Topre Corporation HHKB Professional
>> Bus 002 Device 004: ID 0409:005a NEC Corp. HighSpeed Hub
>> Bus 002 Device 003: ID 0409:0249 NEC Corp.
>> Bus 002 Device 002: ID 2019:ab50 PLANEX GW-US54Mini2
>> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> $ uname -a
>> Linux localhost 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x86_64 GNU/Linux
>>
>> Plz anyone describe me why this one has another vendor-productID, and will this one supported?
>
> It looks like this device is supported in the latest ar9170usb driver. I can't really find in which kernel
> release support for this device has been added, but I'm almost certain that this was after 2.6.32 had been
> released (it is more likely that 2.6.34 is the first kernel release that supports your device).
>
> In other words, the kernel version that you are testing with is simply too old to support the device.
> I guess you need to upgrade to a later kernel version (or use compat-wireless).
>
> ---
> Gertjan.
>

