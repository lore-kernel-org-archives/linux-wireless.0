Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54531 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab1K2RMr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 12:12:47 -0500
Message-ID: <4ED51289.6020008@candelatech.com> (sfid-20111129_181250_378942_14F703D3)
Date: Tue, 29 Nov 2011 09:12:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] iw: Support ht-capability overrides mask.
References: <1322505622-13446-1-git-send-email-greearb@candelatech.com>  (sfid-20111128_194043_702798_6A11361F) <1322556714.4110.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1322556714.4110.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2011 12:51 AM, Johannes Berg wrote:
> On Mon, 2011-11-28 at 10:40 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Let user know which capabilities are supported.
>
> I applied this with a bunch of modifications, but I think you should
> follow up and make it more complete. You're covering exactly and only
> the case that you're working on right now, I don't think that's good
> practice.

It would just be adding dead code until I get more kernel changes in?

But, if you can think of any other over-rides you'd like to
see supported, I can attempt to cook up some kernel patches
as well.

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

