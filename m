Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39965
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbXCZUjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 16:39:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
Date: Mon, 26 Mar 2007 22:39:31 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net> <460730FF.1050603@lwfinger.net> <1174911202.3238.15.camel@pmac.infradead.org>
In-Reply-To: <1174911202.3238.15.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703262239.31415.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 March 2007 14:13, David Woodhouse wrote:
> On Sun, 2007-03-25 at 21:33 -0500, Larry Finger wrote:
> > Joseph has fixed the problem in initb5 (the first hunk), but the second hunk is still not in the new
> > specs. It was in the previous version in a slightly different form, but was found largely by trial
> > and error.
> > 
> > I would prefer that this patch go forward as is so that we don't end up with this bug in the
> > released version of 21.6.21. I am in the process of making the initg code match the current specs,
> > but that will certainly require more testing than I think we have time to complete before 2.6.21 is
> > released. 
> 
> FWIW I tried the mac80211 version (with v4 firmware) and saw very
> similar machine checks, even after trying to apply the same 'fixes'.

logs...

-- 
Greetings Michael.
