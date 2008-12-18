Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:53818 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbYLRWuY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 17:50:24 -0500
Message-ID: <494AD390.7090900@warmcat.com> (sfid-20081218_235028_772394_67F03375)
Date: Thu, 18 Dec 2008 22:49:52 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Werner Almesberger <werner@openmoko.org>,
	linux-wireless@vger.kernel.org
Subject: Re: AR6k: to rfkill
References: <20081218212234.GI5019@almesberger.net> <200812182337.56050.mb@bu3sch.de> <494AD243.5070602@warmcat.com> <200812182343.09528.mb@bu3sch.de>
In-Reply-To: <200812182343.09528.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

>>>> In the same manner as we switch bluetooth, I have asked Werner to write 
>>>> a patch that will use rfkill to issue the IOCTL to switch the AR6001 
>>>> into low power / no RF mode.
>>>>
>>>> Does that raise any eyebrows?
>>> Is the wireless kernel driver a binary blob?
>> No, Openmoko won't have anything to do with in-kernel binary blobs. 
>> There is binary firmware in it in flash though.
> 
> Ok, it just sounded like this, because you were talking about ioctl and stuff...
> 
> So if you receive a kill event, just send the command that puts the device into
> low power state to the device. I think that's perfectly fine.

That's what I figured... Okie Werner, look forward to your patch.  Sorry 
for the noise.

-Andy

