Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:48085 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab3GZOXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 10:23:21 -0400
Received: by mail-ee0-f50.google.com with SMTP id d51so152099eek.23
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jul 2013 07:23:20 -0700 (PDT)
Content-Type: text/plain; charset=iso-8859-8-i; format=flowed; delsp=yes
To: "Oleksij Rempel" <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: TP-LINK wireless USB adapter don't work.
References: <op.w0sd9ujye4gg2u@xp> <51F16993.20207@rempel-privat.de>
Date: Fri, 26 Jul 2013 17:22:53 +0300
MIME-Version: 1.0
From: atar <atar.yosef@gmail.com>
Message-ID: <op.w0t16tbme4gg2u@xp> (sfid-20130726_162334_208123_63E652EF)
In-Reply-To: <51F16993.20207@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you about your answer, but how can I install the firmware? which  
processes are need to be taken in order to accomplish the firmware  
installation and configuration?

Thanks in advance!!

atar.

> Am 25.07.2013 18:47, schrieb atar:
>> Hi there!!
>>
>> I've a TP-LINK USB wireless adapter with model number TL-WN722N. When I
>> plug it in to one of the USB slots in my PC, its LED diode isn't
>> flashing (although under WIN XP it is flashing) and I cannot use it.
>> from the messages of the 'dmesg' command it seems that the kernel detect
>> it, but I unable to use it because it doesn't appear on the wicd window
>> of available interfaces.
>>
>> My Linux distro is Debian squeeze with kernel 2.6.32-5-686.
>>
>> What should I do in order to solve this problem?
>
> It is ath9k-htc based adapter. Please update your kernel and use latest  
> firmware. I think Debian squeeze do not provided this firmware, so you  
> should install it manually.
>
>
