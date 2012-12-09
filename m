Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:45537 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab2LIVCN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 16:02:13 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so946337qad.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Dec 2012 13:02:13 -0800 (PST)
Message-ID: <50C4FC51.4090201@lwfinger.net> (sfid-20121209_220216_948422_820AB8F1)
Date: Sun, 09 Dec 2012 15:02:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0JbRg9C20LPQvtCy?=
	<ramzeth@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about rtl8188RU chipset.
References: <CAJeN2nsAtS_v6amDnWhbGQURmNeca0L0k_3icjzCYnKk2PweaQ@mail.gmail.com>
In-Reply-To: <CAJeN2nsAtS_v6amDnWhbGQURmNeca0L0k_3icjzCYnKk2PweaQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2012 10:03 AM, Дмитрий Жужгов wrote:
> Hello.
> I have a problem using ALFA AWUS036nhr card, with rtl8188RU chipset in
> BackTrack R3, with best suitable (as posted on forums) compat-wireless
> driver for rtl8192CU chipset.

What compat-wireless version are you using? The "best" compat version to use is 
the compat-drivers version released on 12-04-2012.

> Problems are following:
> 1. Airodump-ng , shows that all clients are "no assocciated".
> 2. Can't change TX power above 20dBm even in BO region.
> 3. Can't connect to AP with WPA using WiCd, because "bad password".
> 4. When using WireShark i can't any "Probe Response" frame.
>
> Looking at WEB i've found many similar issues:
> http://www.backtrack-linux.org/forums/showthread.php?t=45323&highlight=awus036nhr
> http://hezik.nl/alfa-awus036nhr-chip-rtl8188ru-compat-wireless-driver-install/#
> http://forum.aircrack-ng.org/index.php?topic=14146.0
> http://forum.aircrack-ng.org/index.php?topic=11543.30
>
>
> Can you explain me about supporting this chipset, who can I contact
> and what can i do to solve this problem ?

I had not tested my Alfa AWUS036NHR recently. The kernel driver works with the 
RTL8192CU chip, but apparently fails with the RTL8188RU. Obviously, that needs 
to be fixed, but I cannot estimate when that will happen.

The Linux driver contained within the file named 
RTL8192xC_USB_linux_v3.4.4_4749.20121105.zip on the Realtek web site does work. 
It needs patching to build on 64-bit systems and on kernel 3.7. If you want the 
patch, please contact me with PM. I see no need to send that patch to all 
subscribers of the wireless ML.

Larry
