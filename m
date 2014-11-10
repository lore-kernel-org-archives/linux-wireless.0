Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51603 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaKJKcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 05:32:07 -0500
Message-ID: <1415615519.1847.10.camel@sipsolutions.net> (sfid-20141110_113211_642152_4989E776)
Subject: pull-request: mac80211 2014-11-10
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 10 Nov 2014 11:31:59 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

One more for 3.18, if possible.

johannes

The following changes since commit b8fff407a180286aa683d543d878d98d9fc57b13:

  mac80211: fix use-after-free in defragmentation (2014-11-03 14:28:50 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-11-10

for you to fetch changes up to 4f031fa9f188b2b0641ac20087d9e16bcfb4e49d:

  mac80211: Fix regression that triggers a kernel BUG with CCMP (2014-11-06 12:42:22 +0100)

----------------------------------------------------------------
This has just one fix, for an issue with the CCMP decryption
that can cause a kernel crash. I'm not sure it's remotely
exploitable, but it's an important fix nonetheless.

----------------------------------------------------------------
Ronald Wahl (1):
      mac80211: Fix regression that triggers a kernel BUG with CCMP

 net/mac80211/aes_ccm.c | 3 +++
 1 file changed, 3 insertions(+)


