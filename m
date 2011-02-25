Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57587 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1BYGPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 01:15:40 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: johannes@sipsolutions.net, davem@davemloft.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 18/21]include:net:mac80211.h remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:15:22 -0800
Message-Id: <1298614522-4153-1-git-send-email-justinmattock@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/net/mac80211.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 62c0ce2..04c3fe5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1349,7 +1349,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * DOC: Beacon filter support
  *
  * Some hardware have beacon filter support to reduce host cpu wakeups
- * which will reduce system power consumption. It usuallly works so that
+ * which will reduce system power consumption. It usually works so that
  * the firmware creates a checksum of the beacon but omits all constantly
  * changing elements (TSF, TIM etc). Whenever the checksum changes the
  * beacon is forwarded to the host, otherwise it will be just dropped. That
-- 
1.7.4.1

