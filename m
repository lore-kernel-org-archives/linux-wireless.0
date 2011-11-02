Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56162 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab1KBQkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 12:40:17 -0400
Message-ID: <4EB1726E.5010503@candelatech.com> (sfid-20111102_174021_755410_8F15DCE2)
Date: Wed, 02 Nov 2011 09:40:14 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [wireless-next PATCH v2 1/4] mac80211: Support forcing station
 to disable 11n.
References: <1319840474-2618-1-git-send-email-greearb@candelatech.com>  (sfid-20111029_002128_214854_3ACBE979) <1320220666.3950.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320220666.3950.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/02/2011 12:57 AM, Johannes Berg wrote:
> On Fri, 2011-10-28 at 15:21 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This allows a user to configure a wifi station interface
>> to disable 802.11n, even if the AP and NIC supports it.
>
> You really should've waited for the review on v1 to finish -- this v2 is
> worthless. That makes John think that you addressed all review feedback,
> when really we didn't even finish discussing some points; eventually
> that'll just force me to have my own tree so John isn't confused all the
> time.

I explicitly noted in the comments for several of the patches
that I did not address all of your comments.  I re-posted because
I thought I could at least fix some of your concerns and hopefully
get the patches closer to right and make further reviews easier.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

