Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43190 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900Ab2DLPX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 11:23:29 -0400
Message-ID: <4F86F36E.5010708@candelatech.com> (sfid-20120412_172338_644864_9929C464)
Date: Thu, 12 Apr 2012 08:23:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/10] mac80211: Add more ethtools stats: survey, rates,
 etc
References: <1334166738-28243-1-git-send-email-greearb@candelatech.com>  <1334166738-28243-6-git-send-email-greearb@candelatech.com>  (sfid-20120411_195324_260400_4B452B18) <1334202406.3788.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1334202406.3788.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/11/2012 08:46 PM, Johannes Berg wrote:
> On Wed, 2012-04-11 at 10:52 -0700, greearb@candelatech.com wrote:
>
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -19,6 +19,7 @@
>>   #include "cfg.h"
>>   #include "rate.h"
>>   #include "mesh.h"
>> +#include "../wireless/core.h"
>
> NACK. Don't do that.

Looks like whatever I needed has already been moved somewhere
proper...I can just delete that line and it compiles fine.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

