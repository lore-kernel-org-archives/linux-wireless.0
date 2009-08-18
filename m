Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54290 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZHROzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 10:55:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Javier Cardona <javier@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] rc80211_pid_algo.c: remove unused variable declaration
Date: Tue, 18 Aug 2009 10:53:52 -0400
Message-Id: <1250607232-24870-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  net/mac80211/rc80211_pid_algo.o
net/mac80211/rc80211_pid_algo.c: In function ‘rate_control_pid_rate_init’:
net/mac80211/rc80211_pid_algo.c:304: warning: unused variable ‘si’

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rc80211_pid_algo.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index f6e25d7..699d3ed 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -301,7 +301,6 @@ rate_control_pid_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	struct rc_pid_sta_info *spinfo = priv_sta;
 	struct rc_pid_info *pinfo = priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
-	struct sta_info *si;
 	int i, j, tmp;
 	bool s;
 
-- 
1.6.2.5

