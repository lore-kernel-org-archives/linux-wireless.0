Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:52925
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127Ab2K2I7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 03:59:01 -0500
Message-ID: <50B723CF.20903@posedge.com> (sfid-20121129_095905_535217_3AF229A4)
Date: Thu, 29 Nov 2012 14:28:55 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Remove unused VHT chan code
References: <50B71FA3.7050304@posedge.com> <1354179167.9557.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354179167.9557.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2012 02:22 PM, Johannes Berg wrote:
> On Thu, 2012-11-29 at 14:11 +0530, Mahesh Palivela wrote:
>> From: Mahesh Palivela <maheshp@posedge.com>
>>
>> Cleanup of unused VHT channel config related code.
>
> Huh, good catch, thanks. Applied.

Thanks. Even below also can be removed as cfg80211_chandef_usable() 
checks this at the beginning.

        if (!cfg80211_chandef_valid(chandef))
                return -EINVAL;

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
