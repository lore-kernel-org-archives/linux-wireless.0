Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:58827 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1CDHQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 02:16:47 -0500
Message-ID: <4D709148.2000101@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 15:14:16 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>,
	stefano.brivio@polimi.it, mattias.nissler@gmx.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH net-next] mac80211: remove unused macros
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Compile test only.


Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
---
 net/mac80211/key.h         |    1 -
 net/mac80211/rc80211_pid.h |    3 ---
 net/mac80211/work.c        |    1 -
 3 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 8106aa1..4ddbe27 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -21,7 +21,6 @@
 
 #define WEP_IV_LEN		4
 #define WEP_ICV_LEN		4
-#define ALG_TKIP_KEY_LEN	32
 #define ALG_CCMP_KEY_LEN	16
 #define CCMP_HDR_LEN		8
 #define CCMP_MIC_LEN		8
diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
index 1a873f0..6510f8e 100644
--- a/net/mac80211/rc80211_pid.h
+++ b/net/mac80211/rc80211_pid.h
@@ -24,9 +24,6 @@
 /* Fixed point arithmetic shifting amount. */
 #define RC_PID_ARITH_SHIFT		8
 
-/* Fixed point arithmetic factor. */
-#define RC_PID_ARITH_FACTOR		(1 << RC_PID_ARITH_SHIFT)
-
 /* Proportional PID component coefficient. */
 #define RC_PID_COEFF_P			15
 /* Integral PID component coefficient. */
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 204f0a4..e73c8ca 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -30,7 +30,6 @@
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
-#define IEEE80211_MAX_PROBE_TRIES 5
 
 enum work_action {
 	WORK_ACT_MISMATCH,
-- 
1.6.3.3
