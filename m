Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36594 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbcBXOZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 09:25:42 -0500
Received: by mail-wm0-f48.google.com with SMTP id g62so274144813wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 06:25:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56CDB213.8060004@candelatech.com>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
 <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com>
 <56CC62BC.308@candelatech.com> <CA+XVXffxWtZgfZS=EZGYng6vWMxqnhTdhgxagYXRbKq1iYj0Sg@mail.gmail.com>
 <56CDAEF6.1080606@candelatech.com> <CA+XVXfceVud0OfB5P=s45DCES1D2VGnbtotZvKX2s8FeFh8N0A@mail.gmail.com>
 <56CDB213.8060004@candelatech.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 24 Feb 2016 16:25:27 +0200
Message-ID: <CA+XVXfd1x3xDAOCgsNqvF0p8_T-S02ed0Crv2bictPrAsYjnMg@mail.gmail.com> (sfid-20160224_152546_239957_B0D40E46)
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 24, 2016 at 3:37 PM, Ben Greear <greearb@candelatech.com> wrote:
>
>
> On 02/24/2016 05:32 AM, Arik Nemtsov wrote:
>>
>> On Wed, Feb 24, 2016 at 3:24 PM, Ben Greear <greearb@candelatech.com>
>> wrote:
>>>>
>>>> Also it's pretty easy to just leave the code there and condition the
>>>> check on the 5GHz band. There's no need to remove it.
>>>
>>>
>>>
>>> Ok, so I can enable VHT on any band as long as the 5Ghz band exists and
>>> allows 80Mhz?
>>>
>>
>> No idea about that. I'm not sure how/if rate modulation is regulated
>> on 2GHz. The ISM band itself is supposed to be open (microwave heating
>> etc.) so it seems fine to me.
>> But don't take me up on that. This is lawyer domain.
>
>
> I'm trying to understand your suggestion.
>
> Maybe you mean I change my patch to only disable VHT if band == 5Ghz AND
> 80Mhz is not available?

Yes. But I'm not saying you can enable 2.4GHz VHT in that case. I
don't know about that.
