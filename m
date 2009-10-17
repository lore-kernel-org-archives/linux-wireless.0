Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44135 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbZJQSdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 14:33:22 -0400
Date: Sat, 17 Oct 2009 20:33:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: 2.6.32-rc0-git: oops in wireless, iwl3945 related?
Message-ID: <20091017183320.GF16532@elf.ucw.cz>
References: <20090929171249.GB14405@elf.ucw.cz>
 <1254431783.3959.45.camel@johannes.local>
 <1254432469.3959.46.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254432469.3959.46.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu 2009-10-01 23:27:49, Johannes Berg wrote:
> On Thu, 2009-10-01 at 23:16 +0200, Johannes Berg wrote:
> 
> > > wlan0: Selected IBSS BSSID 02:18:41:de:3f:02 based on configured SSID
> > > wlan0: Trigger new scan to find an IBSS to join
> > > wlan0: Trigger new scan to find an IBSS to join
> > > wlan0: Creating new IBSS network, BSSID f2:d3:80:82:ed:6a
> > > wlan0: Creating new IBSS network, BSSID 52:17:bf:45:d6:9d
> > > skb_over_panic: text:c07b4113 len:130 put:36 head:e4c3edf0
> > 
> > This entire log is very odd ... can you reproduce this easily? printk
> > timestamps would be useful.
> 
> Kinda looks like a race condition, but it's rather odd. I think there's
> a race condition, so I'm going to submit this patch regardless after
> some testing, but if you want please try the patch below.

Well, the problem is not exactly reproducible... it failed to happen
again. So... thanks and I'll keep my eyes open if it returns. 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
