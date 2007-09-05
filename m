Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100AbXIFNpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:45:47 -0400
Message-Id: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 00/21] more mac80211 updates
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Again, a series of mac80211 updates, mostly from me unless otherwise
noted. Notable are:
 * The filter flags change. I haven't seen anybody complain,
   au contraire.
 * reworked VLAN interface patch to work, confident in it now
 * loads of documentation updates
 * include myself as mac80211 maintainer so I get to be be
   blamed for the bugs...

Also includes cleanups.

As previously, these patches apply against wireless-dev but
I have equivalents against net-2.6.24 which I'll give to John
to apply directly instead of posting them too. Of course,
they'll simply be on http://johannes.sipsolutions.net/patches/
so feel free to look there too.

johannes

