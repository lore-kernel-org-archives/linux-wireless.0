Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60240 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab2JXPkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 11:40:09 -0400
Message-ID: <50880BD0.6080603@candelatech.com> (sfid-20121024_174014_159531_EF1881A7)
Date: Wed, 24 Oct 2012 08:40:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] multi-channel/interface TX power handling
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 03:13 AM, Johannes Berg wrote:
> This was the remaining work I had to do in mac80211, but it
> got a little larger because cfg80211 wasn't doing per-vif
> TX power ...
>
> I disallowed setting TX power per hardware now, we could in
> theory do something like set all interfaces in that case, but
> it seemed like a lot of work for very little gain. If someone
> needs it, we can do it later :-)

Is there any good way for user-space to know if kernel supports
old or new version?  Maybe just try to set per wiphy and if that fails,
try to set per vif?

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


