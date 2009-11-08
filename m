Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:6056 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZKHPFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 10:05:31 -0500
Received: by ey-out-2122.google.com with SMTP id 25so50488eya.5
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 07:05:35 -0800 (PST)
Message-ID: <4AF6DE3D.8040905@gmail.com>
Date: Sun, 08 Nov 2009 16:05:33 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Ivo van Doorn <ivdoorn@gmail.com>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/7] rt2x00: Update copyright statements.
References: <1257689905-1611-1-git-send-email-gwingerde@gmail.com> <200911081525.58809.IvDoorn@gmail.com> <200911081548.09279.bzolnier@gmail.com>
In-Reply-To: <200911081548.09279.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/09 15:48, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 08 November 2009 15:25:58 Ivo van Doorn wrote:
> 
>>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>>> index 5c7d74a..3207b83 100644
>>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>>> @@ -3,7 +3,13 @@
>>>  
>>>  	Based on the original rt2800pci.c and rt2800usb.c:
>>>  
>>> -	  Copyright (C) 2004 - 2009 rt2x00 SourceForge Project
>>> +	  Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
>>> +	  Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
>>> +	  Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
>>> +	  Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
>>> +	  Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
>>> +	  Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
>>> +	  Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
>>>  	  <http://rt2x00.serialmonkey.com>
>>>  
>>>  	This program is free software; you can redistribute it and/or modify
>>
>> If Bartlomiej has no objections, we could just update the statements for rt2800lib.c/rt2800lib.h
>> to something similar as rt2800.h:
>>
>> /*
>> 	Copyright (C) 2009 Bartlomiej Zolnierkiewicz
>> 	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>
>> 	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>
>> 	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>
>> 	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>
>> 	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>
>> 	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>
>> 	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>
>>
>> 	This program is free software; you can redistribute it and/or modify
>> ....
>>
>> because not sure if we need the seperate "based on" comment.. But I'll let Bartlomiej
>> decide on this one.
> 
> I think that the original version is correct and also documents new
> development direction well.
> 

To be honest I believe Ivo is right here. The current "based on" way of documenting copyright does seem to suggest that this list of people does not
have any copyright claims to the code in rt2800lib.c. This is not true, as the code is pure copies from their code that was previously in rt2800usb and
rt2800pci. Therefore I believe it is better to have one list of copyright statements.
Obviously we need to preserve the statement that rt2800lib is based on rt2800pci and rt2800usb.

Something like:

 /*                                                                                                      
	Copyright (C) 2009 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>                                
	Copyright (C) 2009 Ivo van Doorn <IvDoorn@gmail.com>                                             
	Copyright (C) 2009 Alban Browaeys <prahal@yahoo.com>                                             
	Copyright (C) 2009 Felix Fietkau <nbd@openwrt.org>                                               
	Copyright (C) 2009 Luis Correia <luis.f.correia@gmail.com>                                       
	Copyright (C) 2009 Mattias Nissler <mattias.nissler@gmx.de>                                      
	Copyright (C) 2009 Mark Asselstine <asselsm@gmail.com>                                           
	Copyright (C) 2009 Xose Vazquez Perez <xose.vazquez@gmail.com>                                   
	<http://rt2x00.serialmonkey.com>                                                                 
                                                                                                
	Based on the original rt2800pci.c and rt2800usb.c.                                               

	This program is free software; you can redistribute it and/or modify
....                                                                      

---
Gertjan.
