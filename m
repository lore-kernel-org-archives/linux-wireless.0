Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40893 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab1K2SSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 13:18:32 -0500
Message-ID: <4ED521F0.3000606@candelatech.com> (sfid-20111129_191835_469534_6BD4BAA2)
Date: Tue, 29 Nov 2011 10:18:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Moving scan logic into work-queue?
References: <4ED520DD.8050606@candelatech.com> <1322590531.4110.29.camel@jlt3.sipsolutions.net>
In-Reply-To: <1322590531.4110.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2011 10:15 AM, Johannes Berg wrote:
> On Tue, 2011-11-29 at 10:13 -0800, Ben Greear wrote:
>> We've talked before about moving the scan logic into the work-queue.
>
> I think you mean ieee80211_work, not work-queue.
>
>> Since my previous attempts at optimizing this code for scanning&  off-channel
>> work didn't stick, I thought I might attempt to convert the scan logic
>> to the work-queue, with hopes of then being able to make another attempt
>> at optimizing things for multiple interfaces&  potentially off-channel work
>> items.
>>
>> Before I start though, I'm hoping for some guidance on how you'd
>> want this implemented.  Or, if you think there are other changes
>> that should go in first, I'll wait...
>
> In any case, yes, please don't work on this now. I need to rework auth&
> assoc handling completely, and get rid of the work items for that etc.
> That will probably mean a large rewrite of the work item logic, possibly
> even removing most of that code.

Ok, I'll wait to see how that turns out.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

