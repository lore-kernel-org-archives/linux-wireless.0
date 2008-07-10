Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:1474 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbYGJUfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 16:35:08 -0400
Message-ID: <48767258.3020400@errno.com> (sfid-20080710_223512_580785_2B3000E8)
Date: Thu, 10 Jul 2008 13:34:32 -0700
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
References: <20080710152415.GK17936@ruslug.rutgers.edu> <4876304E.9070508@errno.com> <20080710193848.GM17936@ruslug.rutgers.edu>
In-Reply-To: <20080710193848.GM17936@ruslug.rutgers.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Thu, Jul 10, 2008 at 08:52:46AM -0700, Sam Leffler wrote:
>   
>> Luis R. Rodriguez wrote:
>>     
>>> The industry currently has different techniques for parsing and using
>>> Country IEs. What I currently propose is to take the common denominator
>>> between what the AP provides, what CRDA has and what the driver can
>>> provide privately through its callback. So the wireless core can keep
>>> as the common denominator between the AP's Country IE and what CRDA
>>> has for the alpha2 provided by the Country IE. Drivers themselves can
>>> further enhance regulatory enforcement by relying on private driver
>>> data if they wish so.
>>>
>>>  
>>>       
>> Can you elaborate on the first sentence?  Are you just saying that some 
>> software blindly trusts the contents of the country IE and doesn't 
>> constrain it's use (as you describe)?  Or are you saying drivers 
>> interpret the contents of the country IE in ways different than spec'd?
>>     
>
> I'm saying drivers and software stacks used tend to vary on how they
> use the country IE. I believe most vendor drivers *never* simply
> use what the AP provides due to considerations about "rogue" APs.
> I can see why too though -- but it just means the spec didn't
> account for these considerations. Hence my suggestion.
>
>   

Can you elaborate on the differences you see in the drivers and software 
stacks?  I haven't encountered significant differences.

    Sam

