Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45500 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1EJRUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 13:20:43 -0400
Message-ID: <4DC973E7.3050405@candelatech.com> (sfid-20110510_192046_730566_4E796A8F)
Date: Tue, 10 May 2011 10:20:39 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k and ath9k bugs still in 2.6.39-rc7
References: <4DC968FD.1040906@candelatech.com> <4DC97189.1090105@openwrt.org>
In-Reply-To: <4DC97189.1090105@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2011 10:10 AM, Felix Fietkau wrote:
> On 2011-05-10 6:34 PM, Ben Greear wrote:
>> As far as I can tell, ath5k is critically broken due to un-initilized
>> spinlock (fixed in the patch I posted a few days ago), and ath9k stations
>> won't work due to PS bugs that Felix posted fixes for yesterday.
> Did you test my patch for that? I couldn't reproduce the issue, so I
> couldn't test whether my patch fully fixes it.

Trying now..I get crashes..but not sure yet who is to blame.

I did test your previous two patches..one of which was NAK'd..those
worked fine.

Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

