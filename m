Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36360
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbXEFBE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2007 21:04:28 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>,
	Jeff Garzik <jeff@garzik.org>
Subject: Merging SSB upstream
Date: Sun, 6 May 2007 03:03:17 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Gary Zambrano <zambrano@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200705060303.17594.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So, now that mac80211 is merged upstream, I think it's
time to merge SSB and the b44-ssb port upstream.
Note that bcm43xx-mac80211 is _not_ ready for upstream, yet.

What do you think? I'd like to merge ssb as-is, although
the embedded-device parts are not quite finished, yet.
But they don't interfere with the non-embedded parts used
by b44 and the bcm43xx PCI cards.
So we _could_ remove the ssb-mips code, but I don't like to
do that for better maintainability. It doesn't hurt anyone IMO.

Some opinions?

-- 
Greetings Michael.
