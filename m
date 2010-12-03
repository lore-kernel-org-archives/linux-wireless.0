Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:55511 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab0LCW2N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 17:28:13 -0500
Date: Sat, 4 Dec 2010 00:28:12 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Richard Purdie <rpurdie@rpsys.net>
Subject: Re: link failure with led_brightness_set - dependencies?
In-Reply-To: <20101203131557.5f7d497f.randy.dunlap@oracle.com>
Message-ID: <alpine.SOC.1.00.1012040025590.1828@math.ut.ee>
References: <alpine.SOC.1.00.1012032204150.26842@math.ut.ee> <20101203131557.5f7d497f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Tried to compile 2.6.37-rc4+git on sparc64 and got this failure during 
> > linking:
> 
> Does that include this recent commit for this problem?
> 
> http://marc.info/?l=git-commits-head&m=129134154722155&w=2

Sorry, it was not a fresh enough pull. It is applied in git HEAD and 
works fine after a git pull.

Well, I did do a fresh git pull before compilation but it got stuck in 
oldconfig for a day until I noticed and so I did not have the latest 
verson during reporting.

-- 
Meelis Roos (mroos@linux.ee)
