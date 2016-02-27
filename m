Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36674 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbcB0S2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2016 13:28:44 -0500
Date: Sat, 27 Feb 2016 10:28:41 -0800
From: Edward Lipinsky <ellipinsky@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: Fix line longer than 80 columns.
Message-ID: <20160227182841.GA3387@gmail.com> (sfid-20160227_192903_578994_F04E0E3D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the checkpatch.pl warning:

WARNING: line over 80 characters

Signed-off-by: Edward Lipinsky <ellipinsky@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index ce4b589..03202df 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1834,7 +1834,8 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
 	}
 	spin_unlock_bh(&pacl_node_q->lock);
 
-	DBG_8723A("%s, free acl_node_queue, num =%d\n", __func__, pacl_list->num);
+	DBG_8723A("%s, free acl_node_queue, num =%d\n", __func__,
+		  pacl_list->num);
 
 	rtw_sta_flush23a(padapter);
 
-- 
1.7.9.5

