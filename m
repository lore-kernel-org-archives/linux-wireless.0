Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.infomaniak.ch ([84.16.68.89]:60397 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZERLMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 07:12:25 -0400
Message-ID: <4A1142A5.2090800@shockfish.com>
Date: Mon, 18 May 2009 13:12:37 +0200
From: Alexandre Becholey <alexandre@shockfish.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: Re: rt73usb Access point status
References: <557754.25367.qm@web51403.mail.re2.yahoo.com> <20090512215817.bd1c6895.cjsthompson@gmail.com> <wf4ovlo25e.fsf@calligramme.charmers> <200905161132.21437.IvDoorn@gmail.com>
In-Reply-To: <200905161132.21437.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo van Doorn wrote:
> On Saturday 16 May 2009, Jon Fairbairn wrote:
>   
>> "Christoph .J Thompson" <cjsthompson@gmail.com> writes:
>>
>>     
>>> On Tue, 12 May 2009 09:16:12 +0100
>>> Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk> wrote:
>>>       
>>>> Is there any prospec of persuading Ralink either to release
>>>> a mended version of the firmware or to free the old version?
>>>>         
>>> I think Ivo van Doorn said he didn't want to bother RaLink with that. I was
>>> thinking about writing to them about it but that's difficult because I don't
>>> really understand the technical specifics of the issue.
>>>       
>> Me neither; in particular, does it work as an AP in Windows?
>> If so, how does it get round the bug in the driver?
>>     
>
> Simply by indicating that every single frame passed to the driver has
> been send out succesfully and thus completely ignoring the real status.
>
> I am awaiting a patch from Alexandre which will add that same behavior
> to rt2x00.
>
> Ivo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
Ok, I'll sent it soon.

I was trying to figure out the problem with the ARP packets when the 
wireless interface is bridged with an ethernet. It seems to be a known 
issue:
https://lists.linux-foundation.org/pipermail/bridge/2009-May/006382.html
http://www.linuxfoundation.org/en/Net:Bridge#It_doesn.27t_work_with_my_Wireless_card.21 
(kinda old... last modification from 2007)

Alexandre
