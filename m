Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32510 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZBNGm1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 01:42:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 22:42:27 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] cfg80211: one fixup and a few cleanups
Date: Fri, 13 Feb 2009 22:41:39 -0800
Message-ID: <1234593702-19750-1-git-send-email-lrodriguez@atheros.com> (sfid-20090214_074231_914011_B5E2267C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This goes on top of my last series. This has a fixup for
drivers reporting the same regulatory domain and some cleanups.

Luis R. Rodriguez (3):
  cfg80211: allow drivers that agree on regulatory to agree
  cfg80211: add assert_cfg80211_lock() to regdom_changed
  cfg80211: rename regdom_changed to regdom_changes() and use it

 net/wireless/reg.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

