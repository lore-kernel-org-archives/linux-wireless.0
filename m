Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49562 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0LHPgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 10:36:40 -0500
Message-ID: <4CFFA604.90802@candelatech.com>
Date: Wed, 08 Dec 2010 07:36:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: Remove spurious warning in mlme.c
References: <1291759599-14698-1-git-send-email-greearb@candelatech.com> <1291795903.3562.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291795903.3562.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/2010 12:11 AM, Johannes Berg wrote:
> On Tue, 2010-12-07 at 14:06 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Seems that we should not be warning if all of the
>> authtry_bsses are already NULL.
>
> Do you keep running into the warning? I'd really like to understand how
> it happens -- it seems to point to a mac80211 bug.
>
> So don't really like this patch.

Yes, it's easily repeatable in my setup when using wpa_supplicant
for non-encrypted VIFS.  I was using around 80 VIFS for most of this testing.

I posted the backtrace to no comment several weeks ago:

http://www.spinics.net/lists/linux-wireless/msg59525.html

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
