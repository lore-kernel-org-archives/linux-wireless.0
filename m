Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45766 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab3JKVky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 17:40:54 -0400
Message-ID: <52587062.9060405@candelatech.com> (sfid-20131011_234057_695853_B92D42F3)
Date: Fri, 11 Oct 2013 14:40:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Add rate-control name to station debugfs.
References: <1381525471-23655-1-git-send-email-greearb@candelatech.com> <52586DA9.5050204@openwrt.org>
In-Reply-To: <52586DA9.5050204@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2013 02:29 PM, Felix Fietkau wrote:
> On 2013-10-11 11:04 PM, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Nice to see what algorithm it's actually using.
> No need for that, you can use this:
> # cat /sys/kernel/debug/ieee80211/phy0/rc/name

Ok, that should work for me.  But, is there any reason we cannot
have a different rate control alg for different stations on same
phy?

I am thinking of allowing such configuration if possible...the
better to compare various rate ctrl algorithms...

Thanks,
Ben

>
> - Felix
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

