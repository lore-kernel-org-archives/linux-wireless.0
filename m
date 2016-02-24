Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38479 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166AbcBXNhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 08:37:25 -0500
Message-ID: <56CDB213.8060004@candelatech.com> (sfid-20160224_143751_497127_CAAE6BC5)
Date: Wed, 24 Feb 2016 05:37:23 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com> <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com> <56CC62BC.308@candelatech.com> <CA+XVXffxWtZgfZS=EZGYng6vWMxqnhTdhgxagYXRbKq1iYj0Sg@mail.gmail.com> <56CDAEF6.1080606@candelatech.com> <CA+XVXfceVud0OfB5P=s45DCES1D2VGnbtotZvKX2s8FeFh8N0A@mail.gmail.com>
In-Reply-To: <CA+XVXfceVud0OfB5P=s45DCES1D2VGnbtotZvKX2s8FeFh8N0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/24/2016 05:32 AM, Arik Nemtsov wrote:
> On Wed, Feb 24, 2016 at 3:24 PM, Ben Greear <greearb@candelatech.com> wrote:
>>> Also it's pretty easy to just leave the code there and condition the
>>> check on the 5GHz band. There's no need to remove it.
>>
>>
>> Ok, so I can enable VHT on any band as long as the 5Ghz band exists and
>> allows 80Mhz?
>>
>
> No idea about that. I'm not sure how/if rate modulation is regulated
> on 2GHz. The ISM band itself is supposed to be open (microwave heating
> etc.) so it seems fine to me.
> But don't take me up on that. This is lawyer domain.

I'm trying to understand your suggestion.

Maybe you mean I change my patch to only disable VHT if band == 5Ghz AND
80Mhz is not available?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
