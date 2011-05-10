Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45000 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab1EJSgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 14:36:00 -0400
Message-ID: <4DC9858D.5010308@openwrt.org> (sfid-20110510_203604_564355_EFA60C4D)
Date: Tue, 10 May 2011 20:35:57 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k and ath9k bugs still in 2.6.39-rc7
References: <4DC968FD.1040906@candelatech.com> <4DC97189.1090105@openwrt.org> <4DC97A85.40109@candelatech.com>
In-Reply-To: <4DC97A85.40109@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-10 7:48 PM, Ben Greear wrote:
> On 05/10/2011 10:10 AM, Felix Fietkau wrote:
>>  On 2011-05-10 6:34 PM, Ben Greear wrote:
>>>  As far as I can tell, ath5k is critically broken due to un-initilized
>>>  spinlock (fixed in the patch I posted a few days ago), and ath9k stations
>>>  won't work due to PS bugs that Felix posted fixes for yesterday.
>>  Did you test my patch for that? I couldn't reproduce the issue, so I
>>  couldn't test whether my patch fully fixes it.
>
> Better hold off on that patch..looks like the culprit.  Maybe vif is not NULL but
> still bogus?
I think I know where the bug is, I'll send a v2 soon.

- Felix
