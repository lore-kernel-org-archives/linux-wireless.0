Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:57334 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaDSQdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 12:33:52 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so2382016pbc.16
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2014 09:33:52 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/3] fix and improvements
Date: Sun, 20 Apr 2014 00:32:36 +0800
Message-Id: <cover.1397924746.git.gamerh2o@gmail.com> (sfid-20140419_183357_983959_27143F8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think the first patch should also be applied to 3.15.

Zhao, Gang (3):
  cfg80211: fix incorrect checking of return value
  cfg80211/mac80211: rename cfg80211_chandef_dfs_required()
  cfg80211: change variable name

 include/net/cfg80211.h |   6 +--
 net/mac80211/ibss.c    |  40 ++++++++---------
 net/mac80211/mesh.c    |  16 +++----
 net/wireless/chan.c    |  32 +++++++------
 net/wireless/mesh.c    |  22 ++++-----
 net/wireless/nl80211.c | 120 ++++++++++++++++++++++++-------------------------
 net/wireless/trace.h   |   2 +-
 7 files changed, 118 insertions(+), 120 deletions(-)

-- 
1.9.0

