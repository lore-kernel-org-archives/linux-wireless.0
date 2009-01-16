Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35256 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZAPPQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 10:16:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: [b43] opensource firmware
Date: Fri, 16 Jan 2009 16:15:42 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <9FB118DA-845D-4708-84F3-4D51837D8C68@gmail.com> <200901151709.49811.mb@bu3sch.de> <20090115231743.GC7488@bombadil.infradead.org>
In-Reply-To: <20090115231743.GC7488@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901161615.42546.mb@bu3sch.de> (sfid-20090116_161624_482580_07981CE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 January 2009 00:17:43 Kyle McMartin wrote:
> On Thu, Jan 15, 2009 at 05:09:49PM +0100, Michael Buesch wrote:
> > Already implemented here:
> > http://bu3sch.de/patches/wireless-testing/20081227-1821/patches/008-b43-probe-open-fw.patch
> > I just need to fix a leak in an error path before pushing that upstream.
> > 
> 
> Groovy, I had cooked a similar patch for Fedora but haven't gotten
> around to packaging up the fw yet. Will sub in yours.

I think we can actually push my patch upstream. The remaining FIXME is not relevant
for the common case and it only matters in rare circumstances (I think A-PHY only, which
isn't implemented anyway). So we can fix it later.
The patch should work properly as-is for G/N/LP-PHY.

It probably needs a rediff against a current b43, however.

-- 
Greetings, Michael.
