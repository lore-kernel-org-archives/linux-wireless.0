Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49873 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0JLPfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 11:35:08 -0400
Message-ID: <4CB48026.6090507@candelatech.com>
Date: Tue, 12 Oct 2010 08:35:02 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] ath5k:  Move debugfs under ieee80211/[wiphy-name]
References: <1286824841-30822-1-git-send-email-greearb@candelatech.com> <1286870584.3753.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286870584.3753.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2010 01:03 AM, Johannes Berg wrote:
> On Mon, 2010-10-11 at 12:20 -0700, greearb@candelatech.com wrote:
>
>>   void
>>   ath5k_debug_init(void)
>>   {
>> -	ath5k_global_debugfs = debugfs_create_dir("ath5k", NULL);
>>   }
>
> I didn't really intend for my patch to get merged -- at least you should
> also remove this now useless function and its callers and prototypes.

I'll send an updated patch later today.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
