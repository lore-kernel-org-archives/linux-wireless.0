Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32782 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab1EEOuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 10:50:51 -0400
Message-ID: <4DC2B941.6@candelatech.com> (sfid-20110505_165053_874968_6012B8B5)
Date: Thu, 05 May 2011 07:50:41 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH 3/3] cfg80211/nl80211: add interval attribute for scheduled
 scans
References: <1304600420-24227-1-git-send-email-coelho@ti.com>	 <1304600420-24227-4-git-send-email-coelho@ti.com>	 <4DC2B78E.3000205@candelatech.com> <1304607108.3594.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1304607108.3594.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 07:51 AM, Johannes Berg wrote:
> On Thu, 2011-05-05 at 07:43 -0700, Ben Greear wrote:
>> On 05/05/2011 06:00 AM, Luciano Coelho wrote:
>>> Introduce NL80211_ATTR_SCHED_SCAN_INTERVAL as a required attribute for
>>> NL80211_CMD_START_SCHED_SCAN.  This value informs the driver at which
>>> intervals the scheduled scan cycles should be executed.
>>
>> Please default to something useful instead of requiring
>> this so that things are backwards compatible.
>
> Backward compatible to what?

To anything sending older style netlink messages?

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
