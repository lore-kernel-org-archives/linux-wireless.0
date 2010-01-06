Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:52148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab0AFAeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 19:34:25 -0500
Received: by fg-out-1718.google.com with SMTP id 19so6896443fgg.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 16:34:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B43D513.3030300@gmail.com>
References: <4B43C496.4040609@gmail.com> <69e28c911001051548ke40422ao49cb3ad2a141a33a@mail.gmail.com>
	<4B43D513.3030300@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 6 Jan 2010 01:34:03 +0100
Message-ID: <69e28c911001051634m464b3c48r941e202ec533920f@mail.gmail.com>
Subject: Re: b43: must set qos=0 on to connect
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/6 John Daiker <daikerjohn@gmail.com>:
> On 01/05/2010 03:48 PM, Gábor Stefanik wrote:
>>
>> On Wed, Jan 6, 2010 at 12:00 AM, John Daiker<daikerjohn@gmail.com>  wrote:
>>>
>>> I have a BCM4312 rev 01 (14e4:4315) card in my HP Mini netbook.  I am
>>> having
>>> troubles connecting to any WEP secured AP.
>>>
>>> I know the trick about having to load with pio=1 for the device to stay
>>> happy (and forget about using DMA), so no issues there, I hope.
>>>
>>> With qos=1 (by default, IIRC), I am unable to establish a connection with
>>> said WEP connection, and notice many 'PHY transmission error' messages in
>>> my
>>> dmesg output.
>>>
>>> With qos=1, I can successfully connect to my WEP connection without
>>> issue,
>>> and without any error messages or warnings.
>>>
>>> I have a BCM4318 rev 02 (14e4:4318) in a desktop that works with
>>> enabled/disabled qos not matter what.  Also, a RT2500-based card works
>>> fine
>>> on the connection as well.
>>>
>>> Both card are using the 478.104 firmware.
>>>
>>> Please advise what steps I should take to further debug this issue.
>>>
>>> Thanks,
>>> John Daiker
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> Hi!
>>
>> Is this the new 4312 (BCM94312HMGB AKA 575920-001), with integrated
>> Bluetooth? I haven't seen this issue on my machines with a regular
>> 4312, so it is probably related to the DMA error, or maybe it is
>> specific to the new 4312. If you can, please check whether the actual
>> model number printed on the card is the new one.
>>
>> Thanks,
>> Gábor
>>
>
> Gábor,
>
> I just pulled the card, and it's not the chip you mention.  It's a
> "BCM94312HMG"  (Notice that it doesn't have the "B" at the end.  I would
> assume that indicates the Bluetooth integration.)
>
> I've taken few photos of the front and back of the card.  Let me know if you
> want to see them... I can post 'em on my website or flickr for your viewing
> pleasure.
>
> Thanks,
> John Daiker
>

Weird... I also have a 94312HMG, and it doesn't show this error (at
least not in DMA mode).

Maybe this is a PIO-specific issue... I'll try to test that.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
