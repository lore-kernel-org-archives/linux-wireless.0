Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:28419 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYGJUph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 16:45:37 -0400
Received: by an-out-0708.google.com with SMTP id d40so716599and.103
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 13:45:36 -0700 (PDT)
Message-ID: <43e72e890807101345h66d8d18aofc89dea358155cf8@mail.gmail.com> (sfid-20080710_224541_374639_F78B8AFD)
Date: Thu, 10 Jul 2008 13:45:36 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Sam Leffler" <sam@errno.com>
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48767258.3020400@errno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080710152415.GK17936@ruslug.rutgers.edu>
	 <4876304E.9070508@errno.com>
	 <20080710193848.GM17936@ruslug.rutgers.edu>
	 <48767258.3020400@errno.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 10, 2008 at 1:34 PM, Sam Leffler <sam@errno.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Thu, Jul 10, 2008 at 08:52:46AM -0700, Sam Leffler wrote:
>>
>>>
>>> Luis R. Rodriguez wrote:
>>>
>>>>
>>>> The industry currently has different techniques for parsing and using
>>>> Country IEs. What I currently propose is to take the common denominator
>>>> between what the AP provides, what CRDA has and what the driver can
>>>> provide privately through its callback. So the wireless core can keep
>>>> as the common denominator between the AP's Country IE and what CRDA
>>>> has for the alpha2 provided by the Country IE. Drivers themselves can
>>>> further enhance regulatory enforcement by relying on private driver
>>>> data if they wish so.
>>>>
>>>>
>>>
>>> Can you elaborate on the first sentence?  Are you just saying that some
>>> software blindly trusts the contents of the country IE and doesn't constrain
>>> it's use (as you describe)?  Or are you saying drivers interpret the
>>> contents of the country IE in ways different than spec'd?
>>>
>>
>> I'm saying drivers and software stacks used tend to vary on how they
>> use the country IE. I believe most vendor drivers *never* simply
>> use what the AP provides due to considerations about "rogue" APs.
>> I can see why too though -- but it just means the spec didn't
>> account for these considerations. Hence my suggestion.
>>
>>
>
> Can you elaborate on the differences you see in the drivers and software
> stacks?  I haven't encountered significant differences.

I rather not get into details. Lets just try to shoot for some good
solution. That's what we are after anyway. Do you have any feedback on
the strategy I'm proposing? Can the BSD community also make some use
of CRDA? The license is ISC so you should be able to benefit too.

  Luis
