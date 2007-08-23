Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:41140 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759703AbXHWVyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 17:54:09 -0400
Message-ID: <46CE018B.3000707@hhs.nl>
Date: Thu, 23 Aug 2007 23:52:11 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <200708201351.45575.chunkeey@web.de> <46CD6E5F.9040601@hhs.nl> <200708231643.43741.chunkeey@web.de>
In-Reply-To: <200708231643.43741.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Thursday, 23. August 2007, Hans de Goede wrote:
>> I'm afraid that my reception quality varies wildly. I don't know why, I'll try 
>> to configure a different channel on the AP the next time I do some testing.
>>
> Ok, maybe someone has cooked a meal in a microwave oven, or
> something like that...
>  
>> Replying to other mail in one go:
>>
>> Chr wrote:
>>  > I made two patches:
>>  >
>>  > the p54-pull-padding.diff should finally fix the rate algorithm for 
>> "everyone" and as
>>  > a bonus for developers: it adds a printk for the firmware revision p54 is using.
>>  >
>>
>> Cool I'll give this a try tonight, I really wanted to try it sooner, but ...
>>
> k, I'll wait ;-)
> 
> BTW: There's already a newer version of it... see attachment.
> 

Okay, I've given this a test together with your remvoe QOS and other advanced 
features patch and it seems to work well (as good as the versiono of the driver 
I'm currently using).

I've tried using all other firmwares from here:
http://jbnote.free.fr/prism54usb/data/firmwares/

But none of them work, except for the (identical) 2.4.12.0 one. the others 
either don't boot or can't read the eeprom.

Regards,

Hans
