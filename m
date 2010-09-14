Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:39706 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab0INP1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 11:27:05 -0400
Message-ID: <4C8F9418.7060208@candelatech.com>
Date: Tue, 14 Sep 2010 08:26:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [virtual-sta 1/3] mac80211:  Add more general interface iterator.
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com>	 <1284469166.3704.3.camel@jlt3.sipsolutions.net>	 <4C8F8B0D.8050902@candelatech.com> <1284475980.3704.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1284475980.3704.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2010 07:53 AM, Johannes Berg wrote:
> On Tue, 2010-09-14 at 07:47 -0700, Ben Greear wrote:
>
>> I'll see if I can get ath9k to use the normal iterator.  I didn't need my
>> own iterator, because I could just pass in NULL for iterator and pass
>> active_only as false.
>
> active_only as false still doesn't seem right. Why would you care about
> it before an interface is up?

It 'fixed' the bssid mask logic in ath9k, but based on feedback from ath9k
folks, there may be a better way to do that anyway.

I'm going to start integrating the new suggestions now to see if
they work.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
