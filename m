Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45745 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3GZPA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 11:00:26 -0400
Received: by mail-wg0-f45.google.com with SMTP id x12so2990185wgg.24
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jul 2013 08:00:24 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <op.w0t16tbme4gg2u@xp>
References: <op.w0sd9ujye4gg2u@xp>
	<51F16993.20207@rempel-privat.de>
	<op.w0t16tbme4gg2u@xp>
Date: Fri, 26 Jul 2013 17:00:24 +0200
Message-ID: <CA+icZUVbHkKz7VLs-NoVf47S_fUF855aho0CSGG3p5skpRDNmg@mail.gmail.com> (sfid-20130726_170029_354747_B1B08D09)
Subject: Re: TP-LINK wireless USB adapter don't work.
From: Sedat Dilek <sedat.dilek@gmail.com>
To: atar <atar.yosef@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 4:22 PM, atar <atar.yosef@gmail.com> wrote:
> Thank you about your answer, but how can I install the firmware? which
> processes are need to be taken in order to accomplish the firmware
> installation and configuration?
>

Please, do not top-post.

You should get a bit familiar with your operating system.
This mailing-list is no $distro support-channel.

We now have Debian/wheezy (v7.x)!
You should upgrade (check release-notes and upgrade-process).
Can't say off-hand which of the firmware-package you need, just check
by yourself [1] (wild speculation: install firmware-linux-nonfree) or
consult one of Debian's WiFi wiki-pages.
Or ask on Debian's IRC channel for users - it's sometimes faster.

- Sedat -

[1] http://packages.debian.org/search?keywords=firmware

> Thanks in advance!!
>
> atar.
>
>> Am 25.07.2013 18:47, schrieb atar:
>>>
>>> Hi there!!
>>>
>>>
>>> I've a TP-LINK USB wireless adapter with model number TL-WN722N. When I
>>> plug it in to one of the USB slots in my PC, its LED diode isn't
>>> flashing (although under WIN XP it is flashing) and I cannot use it.
>>> from the messages of the 'dmesg' command it seems that the kernel detect
>>> it, but I unable to use it because it doesn't appear on the wicd window
>>> of available interfaces.
>>>
>>> My Linux distro is Debian squeeze with kernel 2.6.32-5-686.
>>>
>>> What should I do in order to solve this problem?
>>
>>
>> It is ath9k-htc based adapter. Please update your kernel and use latest
>> firmware. I think Debian squeeze do not provided this firmware, so you
>> should install it manually.
>>
>>
> --
>
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
