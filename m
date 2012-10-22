Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59087 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab2JVV0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 17:26:42 -0400
Message-ID: <5085BA0E.6080903@candelatech.com> (sfid-20121022_232645_395818_95525E1C)
Date: Mon, 22 Oct 2012 14:26:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Cannot bring up second VAP on recent kernels?
References: <5085AA78.1080809@candelatech.com> <5085B866.8060306@openwrt.org>
In-Reply-To: <5085B866.8060306@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2012 02:19 PM, Felix Fietkau wrote:
> On 2012-10-22 10:20 PM, Ben Greear wrote:
>> Anyone successfully using more than one virtual AP on
>> 3.3 or higher kernels?  It works fine for me on 3.0.32,
>> but my 3.3.8 and 3.5.7 kernels (and a few similar ones)
>> all fail with errors like this below:
>>
>> Hardware is ath9k 3x3 9380 NIC.
> Are you using one hostapd instance per vap, or one hostapd instance for
> all of them?

One hostapd per VAP.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

