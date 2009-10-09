Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:34954 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760525AbZJIKQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 06:16:12 -0400
Received: by fg-out-1718.google.com with SMTP id 22so250492fge.1
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2009 03:14:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910091139.36089.mb@bu3sch.de>
References: <200910091139.36089.mb@bu3sch.de>
Date: Fri, 9 Oct 2009 12:14:24 +0200
Message-ID: <69e28c910910090314j4e9885dfofbc58e901965b4ab@mail.gmail.com>
Subject: Re: Broadcom cards for free
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sounds interesting... especially now that N-PHY is actually being
reverse-engineered (or is it?).

The modded 4320 is an attempt to replace the built-in OS and use it
with b43 as a softmac device... am I right?

On 10/9/09, Michael Buesch <mb@bu3sch.de> wrote:
> Hi,
>
> I've currently got two Broadcom cards to offer for free.
> http://bu3sch.de/misc/bcmcards.JPG
>
> The cardbus one is a WPC300N V1 802.11n card.
> It can be used for development of the b43 N-PHY code.
>
> The USB one is BCM4320 which works over RNDIS-WLAN.
> This device is disassembled and the EEPROM, which contains
> the on-board operating system, is unsoldered and connected through a
> pinheader.
> That means it can be read and/or reprogrammed outside of the device.
> The RF-shield on the RF-side of the board was removed.
> The device should work properly. It properly registers to the kernel, but I
> did
> not try if it works with the rndis-wlan driver.
>
> --
> Greetings, Michael.
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>


-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
