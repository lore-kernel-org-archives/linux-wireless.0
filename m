Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr16.hinet.net ([168.95.4.116]:60750 "EHLO msr16.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1GORNU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 13:13:20 -0400
From: Ali Bahar <ali@internetdog.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Ali Bahar <ali@internetdog.org>
Subject: [PATCH 2/2] staging: r8712u: checkpatch errors: trailing whitespace on 2 lines.
Date: Sat, 16 Jul 2011 01:11:16 +0800
Message-Id: <1310749876-32632-3-git-send-email-ali@internetDog.org> (sfid-20110715_191324_904627_B449B32C)
In-Reply-To: <1310749876-32632-1-git-send-email-ali@internetDog.org>
References: <20110703010605.GA3736@internetdog.org>
 <1310749876-32632-1-git-send-email-ali@internetDog.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ali Bahar <ali@internetDog.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index bb97d8b..6e1c85c 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1009,7 +1009,7 @@ static int r871x_wx_set_priv(struct net_device *dev,
  *
  * Note: Currently (July 2011) r8712_set_802_11_bssid() may fail for one of
  * several reasons. For now, we let -1 be returned as a catch-all failure
- * indication, until that function's implementation is updated. 
+ * indication, until that function's implementation is updated.
  */
 static int r8711_wx_set_wap(struct net_device *dev,
 			 struct iw_request_info *info,
@@ -1121,7 +1121,7 @@ static int r871x_wx_set_mlme(struct net_device *dev,
  * return?
  * The same question arises for bDriverStopped being true.
  *
- */ 
+ */
 static int r8711_wx_set_scan(struct net_device *dev,
 			struct iw_request_info *a,
 			union iwreq_data *wrqu, char *extra)
-- 
1.7.6

