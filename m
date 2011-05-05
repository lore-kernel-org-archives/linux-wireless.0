Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59348 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab1EEQWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 12:22:37 -0400
Message-ID: <4DC2CEC0.2030302@candelatech.com> (sfid-20110505_182242_207814_DB190F75)
Date: Thu, 05 May 2011 09:22:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 3/3] cfg80211/nl80211: add interval attribute for scheduled
 scans
References: <1304600420-24227-1-git-send-email-coelho@ti.com>	 <1304600420-24227-4-git-send-email-coelho@ti.com>	 <4DC2B78E.3000205@candelatech.com>	 <1304607108.3594.6.camel@jlt3.sipsolutions.net>	 <4DC2B941.6@candelatech.com>	 <1304607500.3594.7.camel@jlt3.sipsolutions.net>	 (sfid-20110505_165557_965402_0D829BAA)  <1304607552.3594.8.camel@jlt3.sipsolutions.net>	 <1304610524.12586.403.camel@cumari>  <1304610694.12586.404.camel@cumari> <1304612001.3594.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1304612001.3594.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 09:13 AM, Johannes Berg wrote:
> On Thu, 2011-05-05 at 18:51 +0300, Luciano Coelho wrote:
>
>>>>> But this is a new feature, and a new command, so I don't quite
>>>>> understand why an application would think it can send it without the
>>>>> interval?
>>>>
>>>> Oh wait, I guess you're right, or this should just be part of patch 1
>>>> instead so we never have the feature without the requirement to have the
>>>> interval given.
>>>
>>> Yeah, I could squish this with the previous patch (1/3), but I just
>>> reckoned that patch was getting too big, so I decided to make a separate
>>> one.
>>>
>>> If this whole patch series is taken at the same time, I guess there
>>> won't be backwards compatibility problems (except for bisecting,
>>> maybe?).
>>>
>>> Anyways, I'll leave it as your choice.  Squishing the patch is easy
>>> enough. ;)
>>
>> Ah, and one more thought... There's no driver implementing this at this
>> point, so is there anything to really worry about?
>
> Yeah, good point, no big deal. We can keep it -- I just didn't even
> understand why Ben thought it would not be compatible but it makes sense
> if you just look at the patch by itself.

I was a bit confused..didn't realize it was a new command that had just
been added.  I thought someone was adding a required member to the existing
scan logic.

So, I have no complaints.

Thanks,
Ben


>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

