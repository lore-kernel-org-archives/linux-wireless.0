Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761418Ab2FVHCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 03:02:51 -0400
Message-ID: <1340348566.4491.3.camel@jlt3.sipsolutions.net> (sfid-20120622_090254_918920_2B72246B)
Subject: pull-request: mac80211 2012-06-22
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 22 Jun 2012 09:02:46 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Here's one patch from the TI driver folks that fixes sending out 
bad frames (with all-zeroes BSSID) that we'd like to get into 3.5
still.

johannes


The following changes since commit 79543d8eecc0957ac6fe3ec1e2486ad31d4b67a3:

  mac80211: stop polling in disassociation (2012-06-13 10:17:55 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 88a9e31c506c00c8b7a2f1611406d0e38dcb33b3:

  mac80211: clear ifmgd->bssid only after building DELBA (2012-06-21 21:44:25 +0200)

----------------------------------------------------------------
Eliad Peller (1):
      mac80211: clear ifmgd->bssid only after building DELBA

 net/mac80211/mlme.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


