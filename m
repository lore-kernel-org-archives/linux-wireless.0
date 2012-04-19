Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab2DSEh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 00:37:29 -0400
Message-ID: <4F8F968C.7080301@sipsolutions.net> (sfid-20120419_063732_449378_14912178)
Date: Wed, 18 Apr 2012 21:37:32 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 5/6] mac80211: Add more ethtools stats: survey, rates,
 etc
References: <1334684807-14026-1-git-send-email-greearb@candelatech.com>   <1334684807-14026-6-git-send-email-greearb@candelatech.com>   (sfid-20120417_194713_443684_C3723CAF) <1334713300.3725.18.camel@jlt3.sipsolutions.net>  <4F8E358F.1020501@candelatech.com> <1334721939.3672.4.camel@jlt3.sipsolutions.net> <4F8EE995.9010701@candelatech.com> <4F8F42D2.60808@sipsolutions.net> <4F8F4610.6050908@candelatech.com>
In-Reply-To: <4F8F4610.6050908@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 3:54 PM, Ben Greear wrote:
> On 04/18/2012 03:40 PM, Johannes Berg wrote:
>> On 4/18/2012 9:19 AM, Ben Greear wrote:
>>> Can I add a new API that takes a channel object and returns the
>>> survey results for that? If channel is null, then the API should
>>> return the survey for the current channel if possible.
>>> I'll implement it on ath9k.
>>
>> I don't think you should. It's not nasty anyway since it's built to
>> return all info.
>
> So, for ethtool stats, I can iterate through all available surveys,
> and just report the value that matches the current channel (if any)?

I think so, yes.

johannes
