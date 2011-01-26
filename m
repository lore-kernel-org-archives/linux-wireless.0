Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1AZPWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 10:22:06 -0500
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4D3DF93B.1030702@candelatech.com>
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com>
	 <1295774293.3639.15.camel@jlt3.sipsolutions.net>
	 <4D3DF93B.1030702@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 16:22:03 +0100
Message-ID: <1296055323.3635.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-24 at 14:12 -0800, Ben Greear wrote:
> On 01/23/2011 01:18 AM, Johannes Berg wrote:
> 
> > Also, are you sure the filter configuration works correctly this way? If
> > you can, I'd like to look at a binary trace of the commands going to the
> > device with this change: "trace-cmd record -e mac80211".
> 
> I uploaded two trace files.  One that scans the single operating
> channel, and a second that scans all channels.  This is with my -v2
> patch applied, using ath9k as the driver.  There are two virtual
> STA interfaces configured on this system for this test.
> 
> 
> http://www.candelatech.com/~greearb/trace-scan-all.dat.bz2
> http://www.candelatech.com/~greearb/trace-scan-one.dat.bz2
> 
> Please let me know what you think.

Thanks. I don't think the -one one really is just a single scan? But
anyway, looking at it now.

johannes

