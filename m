Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38082 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbbBXOiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 09:38:10 -0500
Message-ID: <54EC8CD0.5060602@candelatech.com> (sfid-20150224_153813_229390_D4A97EA4)
Date: Tue, 24 Feb 2015 06:38:08 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211-hwsim:  Don't enqueue pkts that do not want
 txstatus.
References: <1423592732-17256-1-git-send-email-greearb@candelatech.com>		 <1424707739.3075.19.camel@sipsolutions.net>		 <54EB6589.6040803@candelatech.com>	 <1424772854.2192.19.camel@sipsolutions.net>	 <54EC8A74.2080700@candelatech.com> <1424788499.2192.32.camel@sipsolutions.net>
In-Reply-To: <1424788499.2192.32.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/24/2015 06:34 AM, Johannes Berg wrote:
> On Tue, 2015-02-24 at 06:28 -0800, Ben Greear wrote:
>
>> If there is no status to return, then why would user-space call back at all?
>>
>> Should user-space *always* return a status even when not requested to?
>
> I'd certainly expect so from hwsim.

I expected just the opposite.  But, I can change my user-space code easily enough.

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
