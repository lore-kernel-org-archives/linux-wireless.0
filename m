Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46690 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030470AbdIZLtr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 07:49:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, toke@toke.dk,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2] mac80211: fix STA_SLOW_THRESHOLD htmldocs failure
Date: Tue, 26 Sep 2017 13:48:05 +0200
Message-Id: <1506426485-7539-1-git-send-email-sgruszka@redhat.com> (sfid-20170926_135118_481139_C5F85564)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes htmldocs build problem:

Error(.//net/mac80211/sta_info.h:416): cannot understand prototype: 'STA_SLOW_THRESHOLD 6000  '

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: just fix documentation build, do not move the code.

 net/mac80211/sta_info.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3acbdfa..a35c964 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -398,7 +398,7 @@ struct ieee80211_sta_rx_stats {
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
 };
 
-/**
+/*
  * The bandwidth threshold below which the per-station CoDel parameters will be
  * scaled to be more lenient (to prevent starvation of slow stations). This
  * value will be scaled by the number of active stations when it is being
-- 
1.7.1
