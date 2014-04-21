Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:53287 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaDUEyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:54:49 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so3346425pab.12
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:54:48 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 00/12] [mac80211-next] minor changes and cleanup
Date: Mon, 21 Apr 2014 12:52:55 +0800
Message-Id: <cover.1398055853.git.gamerh2o@gmail.com> (sfid-20140421_065452_964566_116913AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set includes some renames, I'm not sure it's appropriate to
do this type of thing. :-)

Zhao, Gang (12):
  mac80211: unify debug function
  mac80211: remove config option check
  mac80211: minor changes of ieee80211_reconfig()
  mac80211: return bool instead of numbers in yes/no function
  mac80211: remove unnecessary BUG_ON()
  cfg80211: some workqueue improvements
  cfg80211: change pointer name
  cfg80211: change function name
  cfg80211: change return value of notifier function
  mac80211: change return value of notifier function
  cfg80211/mac80211: rename cfg80211_chandef_dfs_required()
  cfg80211/mac80211: change variable name

 include/net/cfg80211.h     |  10 +-
 net/mac80211/cfg.c         |   6 +-
 net/mac80211/chan.c        |   6 +-
 net/mac80211/ibss.c        |  54 +++----
 net/mac80211/iface.c       |  11 +-
 net/mac80211/main.c        |  12 +-
 net/mac80211/mesh.c        |  20 +--
 net/mac80211/mlme.c        |  12 +-
 net/mac80211/rate.c        |   4 +-
 net/mac80211/rx.c          |  25 +--
 net/mac80211/sta_info.c    |   3 +-
 net/mac80211/tx.c          |   6 +-
 net/mac80211/util.c        |  23 ++-
 net/wireless/chan.c        |  47 +++---
 net/wireless/core.c        |  26 +--
 net/wireless/core.h        |   6 +-
 net/wireless/ethtool.c     |  10 +-
 net/wireless/ibss.c        |  12 +-
 net/wireless/mlme.c        |  24 +--
 net/wireless/nl80211.c     | 396 ++++++++++++++++++++++-----------------------
 net/wireless/reg.c         |   4 +
 net/wireless/scan.c        | 146 ++++++++---------
 net/wireless/sme.c         |  39 ++---
 net/wireless/trace.h       |   2 +-
 net/wireless/util.c        |   2 +-
 net/wireless/wext-compat.c |  32 ++--
 net/wireless/wext-sme.c    |  10 +-
 27 files changed, 474 insertions(+), 474 deletions(-)

-- 
1.9.0

