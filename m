Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53816
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764854AbXGZTkU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 15:40:20 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Date: Thu, 26 Jul 2007 21:38:37 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <46A8ECD6.30204@lwfinger.net> <20070726192601.GD6068@tuxdriver.com>
In-Reply-To: <20070726192601.GD6068@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707262138.38171.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 July 2007 21:26:01 John W. Linville wrote:
> On Thu, Jul 26, 2007 at 01:49:58PM -0500, Larry Finger wrote:
> > John W. Linville wrote:
> > >
> > >Hmmm...well, if you asked to revert it on bcm43xx, why is it appropriate 
> > >here?
> > 
> > AFAIK, the V4 specs have always had the typo, thus there was no patch 
> > introducing this error - it is original. On the other hand, the V3 specs 
> > were modified fairly late in the process, which led to the bcm43xx patch 
> > that needed to be reverted. I suspect that the V3 changes may have been the 
> > result of making them match the V4 specs. If that is the case, it made both 
> > of them wrong.
> > 
> > No matter, the change is needed to make some older cards work. Now I know 
> > why bcm43xx-mac80211 never worked on my BCM4306 until today.
> 
> OK, I get it...I was looking at the patch dwmw2 slipped into F-7 and
> then in my head reverting that (i.e. reversing the reverse patch) --
> my bad!
> 
> Michael, unless you plan to push soon I'll just apply the new patch
> to wireless-dev more-or-less immediately?

Ok, please apply.

-- 
Greetings Michael.
