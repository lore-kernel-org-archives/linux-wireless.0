Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32972 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1AXWMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 17:12:16 -0500
Message-ID: <4D3DF93B.1030702@candelatech.com>
Date: Mon, 24 Jan 2011 14:12:11 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating channel.
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com> <1295774293.3639.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295774293.3639.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2011 01:18 AM, Johannes Berg wrote:

> Also, are you sure the filter configuration works correctly this way? If
> you can, I'd like to look at a binary trace of the commands going to the
> device with this change: "trace-cmd record -e mac80211".

I uploaded two trace files.  One that scans the single operating
channel, and a second that scans all channels.  This is with my -v2
patch applied, using ath9k as the driver.  There are two virtual
STA interfaces configured on this system for this test.


http://www.candelatech.com/~greearb/trace-scan-all.dat.bz2
http://www.candelatech.com/~greearb/trace-scan-one.dat.bz2

Please let me know what you think.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

