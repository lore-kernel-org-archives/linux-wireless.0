Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649Ab2EaHvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 03:51:12 -0400
Message-ID: <1338450650.4531.6.camel@jlt3.sipsolutions.net> (sfid-20120531_095117_069891_8242755B)
Subject: Re: iwlwifi: GF was set with SGI:SISO
From: Johannes Berg <johannes@sipsolutions.net>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Thu, 31 May 2012 09:50:50 +0200
In-Reply-To: <4FC17BA8.2050606@cesarb.net> (sfid-20120527_030308_122290_604E4002)
References: <4FC17BA8.2050606@cesarb.net>
	 (sfid-20120527_030308_122290_604E4002)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cesar,

On Sat, 2012-05-26 at 21:56 -0300, Cesar Eduardo Barros wrote:
> I have twice now seen a problem with iwlwifi where rate control gets 
> "stuck" (the tx bitrate as shown by "iw dev wlan0 link" does not change 
> anymore), while spamming the kernel log with "iwlwifi 0000:03:00.0: GF 
> was set with SGI:SISO".
> 
> The first time, it was stuck at 48 Mbit/s. This time, it got stuck at 81 
> Mbit/s MCS 4 40MHz (long GI) [*]. But this time, I went to 
> /sys/kernel/debug/ieee80211/phy0/netdev:wlan0/stations and got a copy of 
> the rate_* files.
> 
> What I believe is happening is the following scenario:
[...]

Unfortunately, I don't have any idea right away right now what's going
on. Would you file a bug on bugzilla.intellinuxwireless.org so we can
track it and help you better? We may want to reproduce it and/or ask you
to collect some tracing information and it's easier to collect all that
in a bug report.

Thanks,
johannes

