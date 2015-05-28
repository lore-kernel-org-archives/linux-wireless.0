Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57133 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbbE1Mpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 08:45:52 -0400
Message-ID: <1432817149.2459.5.camel@sipsolutions.net> (sfid-20150528_144557_731969_4E6BD953)
Subject: pull-request: mac80211 2015-05-28
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Date: Thu, 28 May 2015 14:45:49 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

Please excuse the quick succession with another pull request - Ben
pointed out to me that a fix I'd applied on -next is actually needed on
4.1 - we'll have to live with it being in both I suppose. Sorry about
that.

johannes


The following changes since commit f9dca80b98caac8b4bfb43a2edf1e9f877ccf322:

  mac80211: fix AP_VLAN crypto tailroom calculation (2015-05-20 15:10:11 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-05-28

for you to fetch changes up to 3a7af58faa7829faa26026c245d2a8a44e9605c5:

  mac80211: Fix mac80211.h docbook comments (2015-05-28 14:37:43 +0200)

----------------------------------------------------------------
This just has a single docbook build fix. In my confusion
I'd already sent the same fix for -next, but Ben Hutchings
noted it's necessary in 4.1.

----------------------------------------------------------------
Jonathan Corbet (1):
      mac80211: Fix mac80211.h docbook comments

 include/net/mac80211.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


