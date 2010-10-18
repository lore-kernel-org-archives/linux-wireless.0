Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56943 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab0JRUFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 16:05:46 -0400
Message-ID: <4CBCA891.9030806@candelatech.com>
Date: Mon, 18 Oct 2010 13:05:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>, greearb@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: [mac80211] mac80211:  Support multiple VIFS per AP in debugfs.
References: <1285212541-6834-1-git-send-email-greearb@candelatech.com> <1285231018.3691.8.camel@jlt3.sipsolutions.net> <201010162100.02477.chunkeey@googlemail.com>
In-Reply-To: <201010162100.02477.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/2010 12:00 PM, Christian Lamparter wrote:
> On Thursday 23 September 2010 10:36:58 Johannes Berg wrote:
>> On Wed, 2010-09-22 at 20:29 -0700, greearb@gmail.com wrote:
>>> From: Ben Greear<greearb@candelatech.com>
>>>
>>> Create 'stations' sub-directory under each netdev:[vif-name]
>>> directory to hold all stations for that network device.
>>>
>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>
>> Acked-by: Johannes Berg<johannes@sipsolutions.net>
>
> ieee80211_debugfs_key_add needs to be updated (debugfs_key.c).
> Either the "station" symlink has to go, or we need to loop up
> to which interface the sta belongs. currently it's hard-coded to
> "sprintf(buf, "../../stations/%pM", sta->sta.addr);"
> (something which no longer exists)

I'm travelling for a few days, but will see what I can do to fix
this when I'm back if no one beats me to it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

