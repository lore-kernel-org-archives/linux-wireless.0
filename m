Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44337 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2FKRXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 13:23:40 -0400
Received: by pbbrp8 with SMTP id rp8so5863679pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 10:23:39 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	rdunlap@xenotime.net, devel@lists.open80211s.org,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH] mac80211: add missing kernel-doc
Date: Mon, 11 Jun 2012 10:23:35 -0700
Message-Id: <1339435415-9417-1-git-send-email-ashok@cozybit.com> (sfid-20120611_192343_428787_BBACA51F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a few kernel-doc descriptions that were missed
during mesh development.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
---
 net/mac80211/sta_info.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3bb24a1..672d9c6 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -271,6 +271,9 @@ struct sta_ampdu_mlme {
  * @plink_timer: peer link watch timer
  * @plink_timer_was_running: used by suspend/resume to restore timers
  * @t_offset: timing offset relative to this host
+ * @t_offset_setpoint: reference timing offset of this sta to be used when
+ * 	calculating clockdrift
+ * @ch_type: peer's channel type
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
-- 
1.7.5.4

