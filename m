Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47221 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1BCPKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 10:10:14 -0500
Message-ID: <4D4AC550.5050204@candelatech.com>
Date: Thu, 03 Feb 2011 07:10:08 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Crash in timer.c
References: <4D49DABE.7040802@candelatech.com> <1296721004.3854.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296721004.3854.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/03/2011 12:16 AM, Johannes Berg wrote:
> On Wed, 2011-02-02 at 14:29 -0800, Ben Greear wrote:
>> I had 128 STA vifs on an ath9k system...started deleting all but 16 of them.
>> I did this twice, and both times, it crashes before finishing deleting
>> all of them.
>>
>> This is using latest wireless-testing plus some of my patches
>> previously posted to this list.
>
> Timers should have debug objects support -- that would be helpful.

Yeah, I was hitting a similar crash before..though I had more debugging
enabled then.  Someone posted ath9k patches that they thought would
fix it..but not sure they did.

I also don't remember seeing this while I had copybreak in my tree
(I recently removed it to make way for the paged skb code...)
That could just be a coincidence though....

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
