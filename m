Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53204 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3AURjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 12:39:13 -0500
Message-ID: <50FD7D34.4050203@candelatech.com> (sfid-20130121_183921_164324_72BC8431)
Date: Mon, 21 Jan 2013 09:39:00 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] cfg80211: move world roaming check for beacon hints
References: <1355943184-966-1-git-send-email-mcgrof@do-not-panic.com>  <1355943184-966-4-git-send-email-mcgrof@do-not-panic.com>  (sfid-20121219_200036_196307_E48D6F1B) <1356628591.15149.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1356628591.15149.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2012 09:16 AM, Johannes Berg wrote:
> On Wed, 2012-12-19 at 10:53 -0800, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> We should not add new beacon hints even if the wiphy
>> is not world roaming. Without this we were always adding
>> a beacon hint if not world roaming for every non world
>> roaming wiphy interface.
>
> This introduced a locking bug, lockdep splat below. I'm going to drop
> the series for my pull request, please respin.

Were new patches ever posted for this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

