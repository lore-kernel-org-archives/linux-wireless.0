Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2FIIGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:06:02 -0400
Message-ID: <1339229158.4539.4.camel@jlt3.sipsolutions.net> (sfid-20120609_100702_697163_6C6742B8)
Subject: Re: kernel-doc warnings (3.5-rc1)
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Date: Sat, 09 Jun 2012 10:05:58 +0200
In-Reply-To: <4FD28ED7.6070506@xenotime.net> (sfid-20120609_014646_473500_8E65425E)
References: <4FD28ED7.6070506@xenotime.net>
	 (sfid-20120609_014646_473500_8E65425E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 16:46 -0700, Randy Dunlap wrote:
> Would someone please add/fix the kernel-doc warnings?

I'll commit the below patch for these:

> Warning(include/net/mac80211.h:2979): No description found for parameter 'band'
> Warning(include/net/mac80211.h:2383): No description found for parameter 'set_wakeup'

> Warning(net/mac80211/sta_info.h:382): No description found for parameter 'supports_40mhz'

For these, however,

> Warning(net/mac80211/sta_info.h:382): No description found for parameter 't_offset_setpoint'
> Warning(net/mac80211/sta_info.h:382): No description found for parameter 'ch_type'

I don't know what they actually should be described as, need a patch
from the mesh people.

johannes

