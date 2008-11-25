Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:43485 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbYKYBmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 20:42:01 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1212680nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 17:41:59 -0800 (PST)
Message-ID: <492B57E8.2010101@gmail.com> (sfid-20081125_024208_076397_608DA504)
Date: Mon, 24 Nov 2008 20:42:00 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>
Subject: Re: wireless-regdb: update regulatory rules for US 2.3-2.4GHz and
 5.65-5.925GHz
References: <492B2E07.9050105@gmail.com> <20081124230427.GM6245@tesla>	 <492B3643.4070904@gmail.com> <43e72e890811241530t44245e4ar3fd5797afcc451c0@mail.gmail.com>
In-Reply-To: <43e72e890811241530t44245e4ar3fd5797afcc451c0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Nov 24, 2008 at 3:18 PM, Richard Farina <sidhayn@gmail.com> wrote:
>   
>> Luis R. Rodriguez wrote:
>>     
>>> On Mon, Nov 24, 2008 at 02:43:19PM -0800, Richard Farina wrote:
>>>
>>>       
>>>> The above frequencies are allowed by FCC part 97 to amateur radio
>>>> operator as primary use, this doesn't even cover the secondary and
>>>> tertiary uses, just where amateurs are primary.
>>>>
>>>>         
>>> NACK -- For the US we use the wireless regulatory database for Part 15
>>> rules with 802.11 in mind.
>>>
>>>
>>>       
>> Not only do I understand your reasoning, but I also agree.  Please do
>> consider the following (from that same email):
>>     
>
> Thanks :)
>
>   
>> This also introduces a new issue in crda of setting not only power limits
>> but power limits based on modulation.  It is permitted to use DSSS up to 100
>> watts, however, OFDM is permitted up to 1500 watts.
>>
>> Would it be an unreasonable request to have crda support modulation
>> restrictions and power limit based on modulation restrictions?
>>     
>
> This is odd, first time I hear about such a thing. Do you have a
> pointer to Part 15 rules which clarifies this?
>
>   
Again, I'm only familiar with FCC regulations but I don't believe this 
is required for Part 15.  The IEEE802.11 rules do allow for some odd 
stuff but the really odd stuff tends to be handled in hardware.  For 
instance, we can only use OFDM on the 5GHz bands, no DSSS is permitted.  
The hardware handles this for us I think, that or somewhere deep dark 
and scary that I've never seen in the driver.  Additionally .11a 
provides three different transmit power levels based on the frequency 
band you are in (and the use case).  What I would need this additional 
feature for is licensed use but I'm sure that somewhere in the world, 
someone has a unlicensed limitation such that would make this relevant.  
I suppose we can all wait around until I can successfully google such a 
case or someone with relevant first hand experience comes along, but 
frankly, if it isn't that painful to do it would allow the licensed 
users a much greater flexibility to use the hardware without 
accidentally breaking the law.  Please consider it a request without 
official requirement, if someone is bored, great, otherwise I'll either 
learn to code better or find someone who is bored :-)

thanks,
Rick Farina

>   Luis
>
>   

