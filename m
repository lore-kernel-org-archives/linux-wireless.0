Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40656 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JVWwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 18:52:13 -0400
Message-ID: <5085CE19.2000505@candelatech.com> (sfid-20121023_005220_062533_306BF2EB)
Date: Mon, 22 Oct 2012 15:52:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Cannot bring up second VAP on recent kernels?
References: <5085AA78.1080809@candelatech.com> <5085B866.8060306@openwrt.org> <5085BA0E.6080903@candelatech.com> <5085BE64.6030802@openwrt.org>
In-Reply-To: <5085BE64.6030802@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2012 02:45 PM, Felix Fietkau wrote:
> On 2012-10-22 11:26 PM, Ben Greear wrote:
>> On 10/22/2012 02:19 PM, Felix Fietkau wrote:
>>> On 2012-10-22 10:20 PM, Ben Greear wrote:
>>>> Anyone successfully using more than one virtual AP on
>>>> 3.3 or higher kernels?  It works fine for me on 3.0.32,
>>>> but my 3.3.8 and 3.5.7 kernels (and a few similar ones)
>>>> all fail with errors like this below:
>>>>
>>>> Hardware is ath9k 3x3 9380 NIC.
>>> Are you using one hostapd instance per vap, or one hostapd instance for
>>> all of them?
>>
>> One hostapd per VAP.
> I had issues with that a long time ago. Use one hostapd instance for all
> vaps on the same wiphy, that'll work better.

Well, that would be a lot of user-space churn for me, so I think
I'll try to figure out why it's failing and see if I can fix it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

