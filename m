Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41387 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806AbbFQNpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 09:45:54 -0400
Message-ID: <55817A0F.2000207@candelatech.com> (sfid-20150617_154604_343501_8BDAFD05)
Date: Wed, 17 Jun 2015 06:45:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw:  Use ifname if available, print new/del/stop events.
References: <1433974675-19225-1-git-send-email-greearb@candelatech.com> <1434532497.1884.27.camel@sipsolutions.net>
In-Reply-To: <1434532497.1884.27.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/17/2015 02:14 AM, Johannes Berg wrote:
> On Wed, 2015-06-10 at 18:17 -0400, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> If the kernel sends the IFNAME in the netlink message, then
>> use it to save the call to map ifindex to name (and
>> potentially fix races, especially when kernel is
>> busy deleting an interface.
>
> Please split the "print new/del/stop events" part into a separate patch
> - I can apply that now.

Some existing events (interface-delete, I think) already have the ifname, by the way..so the iw patch
is useful without any kernel changes.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
