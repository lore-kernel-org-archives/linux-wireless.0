Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:5080 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZKHP1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 10:27:41 -0500
Received: by ey-out-2122.google.com with SMTP id 25so15098eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 07:27:45 -0800 (PST)
Message-ID: <4AF6E36F.1060705@gmail.com>
Date: Sun, 08 Nov 2009 16:27:43 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/7] rt2x00: Update copyright statements.
References: <1257689905-1611-1-git-send-email-gwingerde@gmail.com> <200911081548.09279.bzolnier@gmail.com> <4AF6DE3D.8040905@gmail.com> <200911081615.07387.bzolnier@gmail.com>
In-Reply-To: <200911081615.07387.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 16:15, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 16:05:33 Gertjan van Wingerde wrote:
>> On 11/08/09 15:48, Bartlomiej Zolnierkiewicz wrote:
>>> On Sunday 08 November 2009 15:25:58 Ivo van Doorn wrote:
>>>
>>>>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>>>>> index 5c7d74a..3207b83 100644
>>>>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>>>>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>>>>> @@ -3,7 +3,13 @@
>>>>>  
>>>>>  	Based on the original rt2800pci.c and rt2800usb.c:
>>>>>  
>>>>> -	  Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
>>>>> +	  Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
>>>>> +	  Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
>>>>> +	  Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
>>>>> +	  Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
>>>>> +	  Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
>>>>> +	  Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
>>>>> +	  Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
>>>>>  	  <http://rt2x00.serialmonkey.com>
>>>>>  
>>>>>  	This program is free software; you can redistribute it and/or modify
>>>>
>>>> If Bartlomiej has no objections, we could just update the statements for rt2800lib.c/rt2800lib.h
>>>> to something similar as rt2800.h:
>>>>
>>>> /*
>>>> 	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
>>>> 	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
>>>> 	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
>>>> 	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
>>>> 	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
>>>> 	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
>>>> 	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
>>>> 	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
>>>>
>>>> 	This program is free software; you can redistribute it and/or modify
>>>> ....
>>>>
>>>> because not sure if we need the seperate "based on" comment.. But I'll let Bartlomiej
>>>> decide on this one.
>>>
>>> I think that the original version is correct and also documents new
>>> development direction well.
>>>
>>
>> To be honest I believe Ivo is right here. The current "based on" way of documenting copyright does seem to suggest that this list of people does not
> 
> No, it does not:
> 
>         Copyright (C) 2009 Bartlomiej Zolnierkiewicz
> 
>         Based on the original rt2800pci.c and rt2800usb.c:
> 
>           Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
>           <http://rt2x00.serialmonkey.com>
> 
> and it is wasn't my idea to use rt2x00 project for copyrights in
> the original code.
> 
> I did not do anything shady here -- this is the standard practice used
> in such situations (i.e. libata and I'm pretty sure changes were passed
> through Red Hat's lawyers).

I wasn't saying you were doing something shady here (or at least I didn't intend to do so).

> 
>> have any copyright claims to the code in rt2800lib.c. This is not true, as the code is pure copies from their code that was previously in rt2800usb and
> 
> The code is not "pure copies" from their code and they didn't have personal
> claims on the original code in the first place.
> 
> You are trying to reverse the history now, just keep adding new claims as
> new patches from people flow in.  I fail to see the real problem with it.
> 

Well, I don't see this a reversing history. We just have been sloppy with the copyright statements in the first place, and I'm trying to correct this.

---
Gertjan.
