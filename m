Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9117 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab1GSWBZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 18:01:25 -0400
Message-ID: <4E25FEB3.1030005@gnu.org> (sfid-20110720_000128_369433_5958500D)
Date: Tue, 19 Jul 2011 18:01:23 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Kernel oops in code added by "cfg80211: allow userspace to control
 supported rates in scan"
References: <4E25FA60.7040807@gnu.org>  (sfid-20110719_234302_063697_7FDE84C7) <1311112517.3872.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1311112517.3872.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/19/2011 05:55 PM, Johannes Berg wrote:
> On Tue, 2011-07-19 at 17:42 -0400, Pavel Roskin wrote:
>
>> for (i = 0; i<  IEEE80211_NUM_BANDS; i++)
>>         request->rates[i] = (1<<  wiphy->bands[i]->n_bitrates) - 1;
>
> Ah crap, I didn't pay attention and never tested a single-band card.
> Below change should fix it.

Tested-by: Pavel Roskin <proski@gnu.org>

The ultimate test - sending via the wireless connection :)

-- 
Regards,
Pavel Roskin
