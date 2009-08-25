Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:60287 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbZHYT04 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 15:26:56 -0400
Received: by pzk32 with SMTP id 32so1784148pzk.33
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 12:26:58 -0700 (PDT)
Message-ID: <4A943AFE.1000500@gmail.com>
Date: Tue, 25 Aug 2009 15:26:54 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] atheros: add ar9170.fw 1-stage firmware
References: <1250793627-22396-1-git-send-email-lrodriguez@atheros.com> <4A8DAD1D.7090608@gmail.com> <20090820202817.GB18102@mosca>
In-Reply-To: <20090820202817.GB18102@mosca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Thu, Aug 20, 2009 at 01:07:57PM -0700, Richard Farina wrote:
>   
>> Luis R. Rodriguez wrote:
>>     
>>> This adds support for ar9170 for using a 1-stage firmware.
>>> This means only 1 firmware file is required. AVM Fritz
>>> devices require this.
>>>
>>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>> ---
>>>
>>> Here is a resend, noticed today this wasn't yet in the tree.
>>>
>>>
>>>       
>> Last I tested this firmware it didn't seem to function nearly as well as
>> the 2 stage firmware, and if present, the 1 stage overrides the 2
>> stage. 
>>     
>
> Can you be more specific than that?
>
>   
>> Is this an improved version? 
>>     
>
> No, it is the same firmware.
>
>   
>> Does this work properly in your testing?
>>     
>
> Works for me, and is also required for usage of AVM Fritz devices.
>
>   
I apologize for my confusion.  Since we spoke on irc I am now clear that 
this specific ar9170 firmware is slightly different than the open source 
one available in git and seems a bit more stable than the 2 stage I was 
previously using.  I have tested monitor mode and packet injection which 
are the only things that interest me about this device at the moment and 
both appear slightly more stable using the 1 stage firmware. Please do 
add the firmware located at 
http://www.kernel.org/pub/linux/kernel/people/mcgrof/firmware/ar9170/ar9170.fw 
to the linux firmware git repo.  I believe that it would be a benefit to 
many.

ACKED BY: Rick Farina
TESTED BY: Rick Farina

On a similar note, the open firmware has had issues reported by many 
with speed and stability so I wouldn't recommend using it yet, but this 
is mostly based on the complaints I've heard rather than my own personal 
testing so remember a grain of salt.

Thanks,
Rick Farina

>   Luis
>
>   

