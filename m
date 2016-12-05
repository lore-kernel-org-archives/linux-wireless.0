Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39806 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEOox (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:44:53 -0500
Message-ID: <58457D63.2010605@candelatech.com> (sfid-20161205_154456_328314_72DEE479)
Date: Mon, 05 Dec 2016 06:44:51 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Return avg sig, rx, tx values in ethtool stats.
References: <1480442872-7358-1-git-send-email-greearb@candelatech.com>   (sfid-20161129_190824_045626_457405E8) <1480946891.31788.10.camel@sipsolutions.net>
In-Reply-To: <1480946891.31788.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/05/2016 06:08 AM, Johannes Berg wrote:
> On Tue, 2016-11-29 at 10:07 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> For non-station devices.  This gives at least some useful
>> summary in some cases (especially when we know AP has only one
>> station attached, for instance).
>
> I never saw the point in having ethtool statistics for something you
> can get elsewhere, but I'm certainly not making it return a random
> station's data disregarding everything else. At least the existing ones
> are sums so that all stations are taken into account...

Unless I screwed up, this patch also returns an average.

But, easy enough to carry out of tree, and my use case for this
is pretty specific.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
