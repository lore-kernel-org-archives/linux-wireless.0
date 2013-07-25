Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62938 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962Ab3GYSIX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jul 2013 14:08:23 -0400
Received: from [192.168.2.100] ([93.218.66.75]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MN0jA-1V0E6I0c24-006cJc for
 <linux-wireless@vger.kernel.org>; Thu, 25 Jul 2013 20:08:22 +0200
Message-ID: <51F16993.20207@rempel-privat.de> (sfid-20130725_200843_086751_BCE2ABFA)
Date: Thu, 25 Jul 2013 20:08:19 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: atar <atar.yosef@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: TP-LINK wireless USB adapter don't work.
References: <op.w0sd9ujye4gg2u@xp>
In-Reply-To: <op.w0sd9ujye4gg2u@xp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 25.07.2013 18:47, schrieb atar:
> aHi there!!
>
> I've a TP-LINK USB wireless adapter with model number TL-WN722N. When I
> plug it in to one of the USB slots in my PC, its LED diode isn't
> flashing (although under WIN XP it is flashing) and I cannot use it.
> from the messages of the 'dmesg' command it seems that the kernel detect
> it, but I unable to use it because it doesn't appear on the wicd window
> of available interfaces.
>
> My Linux distro is Debian squeeze with kernel 2.6.32-5-686.
>
> What should I do in order to solve this problem?

It is ath9k-htc based adapter. Please update your kernel and use latest 
firmware. I think Debian squeeze do not provided this firmware, so you 
should install it manually.



-- 
Regards,
Oleksij
