Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57813 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbbESHWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 03:22:36 -0400
Message-ID: <1432020154.7437.1.camel@sipsolutions.net> (sfid-20150519_092244_643435_9EAAEB96)
Subject: pull-request: mac80211 2015-05-19
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 19 May 2015 09:22:34 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

And one more - for the current cycle (and stable as well).

Let me know if there's any problem.

johannes

The following changes since commit ff419b3f95ab7a97c5f72876b53f12a249dacc2a:

  mac80211: fix 90 kernel-doc warnings (2015-05-04 12:56:13 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-davem-2015-05-19

for you to fetch changes up to 47b4e1fc4972cc43a19121bc2608a60aef3bf216:

  mac80211: move WEP tailroom size check (2015-05-11 14:51:29 +0200)

----------------------------------------------------------------
This has just a single fix, for a WEP tailroom check
problem that leads to dropped frames.

----------------------------------------------------------------
Janusz Dziedzic (1):
      mac80211: move WEP tailroom size check

 net/mac80211/wep.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


