Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49617 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab0B1SxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2010 13:53:14 -0500
Received: by fxm19 with SMTP id 19so84279fxm.21
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2010 10:53:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b170af451002281047s1cbb9168g61178c5bc06ad428@mail.gmail.com>
References: <69e28c911002260708g45d3c0f7u6abf13b1babe549f@mail.gmail.com>
	<69e28c911002271145s590df31en9d2f8b2c47932451@mail.gmail.com>
	<4B899DA3.4030100@lwfinger.net> <69e28c911002271534o8cab111vf7fcc1b93b6c4b47@mail.gmail.com>
	<a221c0101002271542o5d928e56n8a22602860aeb761@mail.gmail.com>
	<69e28c911002271544y62c93255k8a6dbb0adb2b5928@mail.gmail.com>
	<20100228001655.4c9fd9ce@boulder.homenet> <4B8AAF42.8000602@polymtl.ca>
	<69e28c911002281042g15808a2cm81bd9528a30d2f85@mail.gmail.com>
	<b170af451002281047s1cbb9168g61178c5bc06ad428@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 28 Feb 2010 19:52:53 +0100
Message-ID: <69e28c911002281052p417fcd42n74552ad3ac0106a2@mail.gmail.com>
Subject: Re: LP-PHY Fatal DMA error 0x00000800 on non-ULV Core 2 Duo?!?!!??!
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: William Bourque <william.bourque@polymtl.ca>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/28 Rafał Miłecki <zajec5@gmail.com>:
> 2010/2/28 Gábor Stefanik <netrolller.3d@gmail.com>:
>> On Sun, Feb 28, 2010 at 7:00 PM, William Bourque
>> <william.bourque@polymtl.ca> wrote:
>>> I confirm, it still crashes on my notebook as well. However the new
>>> "fallback to PIO" behavior introduced earlier do a fine job getting it back
>>> on track.
>>>
>>> Btw, you are often refering to some documentation that document the register
>>> for this device, where could I find it? I probably won't be able to do much,
>>> but I'm curious to see...
>>>
>> New test patch attached.
>
> Patch adds this /incorrect/ ssb_write32 to 0x280a, right? By incorrect
> I mean over range.
>
> Would be nice to see if dumping tool generates same log about 0x280a
> now (for wl and b43 patched).

I added both the "incorrect" 0x280a and the "correct" 0x80a here - it
is possible that the 0x280a one takes advantage of an undocumented
feature in PhoenixBIOS.

>
> --
> Rafał
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
