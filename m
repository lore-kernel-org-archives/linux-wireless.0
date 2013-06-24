Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49568 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3FXOqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 10:46:22 -0400
Message-ID: <51C85BB8.30000@candelatech.com> (sfid-20130624_164625_773794_EC10ED39)
Date: Mon, 24 Jun 2013 07:46:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH-WN 1/3] wireless: Make sure __cfg80211_connect_result
 always puts bss.
References: <1371675987-28732-1-git-send-email-greearb@candelatech.com>  (sfid-20130619_230648_480145_A5400A87) <1372082182.8439.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1372082182.8439.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/24/2013 06:56 AM, Johannes Berg wrote:
> On Wed, 2013-06-19 at 14:06 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Otherwise, we can leak a bss reference.
>
> Applied all 3, still trying to make up my mind about the debugfs one
> patch :)

With regard to that one, how about I allow it to be enabled based on
cfg80211 module option (and only when cfg80211 debugfs is enabled).

That way, no new kernel option, and no significant hit to any runtime
performance unless users specifically enable the feature.

Thanks for applying the other three.

Thanks,
Ben


>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

