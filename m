Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3985 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764853AbXGZTfm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 15:35:42 -0400
Date: Thu, 26 Jul 2007 15:26:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Message-ID: <20070726192601.GD6068@tuxdriver.com>
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <20070726172138.GA6068@tuxdriver.com> <46A8E044.6080206@lwfinger.net> <20070726181334.GB6068@tuxdriver.com> <46A8ECD6.30204@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46A8ECD6.30204@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 26, 2007 at 01:49:58PM -0500, Larry Finger wrote:
> John W. Linville wrote:
> >
> >Hmmm...well, if you asked to revert it on bcm43xx, why is it appropriate 
> >here?
> 
> AFAIK, the V4 specs have always had the typo, thus there was no patch 
> introducing this error - it is original. On the other hand, the V3 specs 
> were modified fairly late in the process, which led to the bcm43xx patch 
> that needed to be reverted. I suspect that the V3 changes may have been the 
> result of making them match the V4 specs. If that is the case, it made both 
> of them wrong.
> 
> No matter, the change is needed to make some older cards work. Now I know 
> why bcm43xx-mac80211 never worked on my BCM4306 until today.

OK, I get it...I was looking at the patch dwmw2 slipped into F-7 and
then in my head reverting that (i.e. reversing the reverse patch) --
my bad!

Michael, unless you plan to push soon I'll just apply the new patch
to wireless-dev more-or-less immediately?

John
-- 
John W. Linville
linville@tuxdriver.com
