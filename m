Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56002 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635Ab3KMRyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:54:11 -0500
Received: by mail-wg0-f49.google.com with SMTP id x13so761272wgg.4
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 09:54:10 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/5] cfg80211: few updates prior to quiesce and exporting DFS regions
Date: Wed, 13 Nov 2013 18:54:01 +0100
Message-Id: <1384365246-24768-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131113_185415_164150_BA50BEC2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a few simple updates for cfg80211 regulatory to help with the
next patches I'll post as RFC's. Nothing major here.

Luis R. Rodriguez (5):
  cfg80211: use enum nl80211_dfs_regions for dfs_region everywhere
  cfg80211: intersection dfs regions when intersecting regdomains
  cfg80211: distinguish unset DFS region from unknown
  cfg80211: replace print_dfs_region() with reg_dfs_region_str() helper
  cfg80211: add reg_get_dfs_region()

 include/net/regulatory.h |  4 +--
 net/wireless/nl80211.c   |  2 +-
 net/wireless/reg.c       | 85 +++++++++++++++++++++++++++++++++++-------------
 net/wireless/reg.h       |  3 +-
 4 files changed, 67 insertions(+), 27 deletions(-)

-- 
1.8.4.rc3

