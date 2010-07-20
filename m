Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34761 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376Ab0GTSPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 14:15:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ipw2100: mark ipw2100_pm_qos_req static
Date: Tue, 20 Jul 2010 14:12:49 -0400
Message-Id: <1279649569-5938-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CHECK   drivers/net/wireless/ipw2x00/ipw2100.c
drivers/net/wireless/ipw2x00/ipw2100.c:177:28: warning: symbol 'ipw2100_pm_qos_req' was not declared. Should it be static?

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ipw2x00/ipw2100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 18ebd60..5165db9 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -174,7 +174,7 @@ that only one external action is invoked at a time.
 #define DRV_DESCRIPTION	"Intel(R) PRO/Wireless 2100 Network Driver"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
 
-struct pm_qos_request_list *ipw2100_pm_qos_req;
+static struct pm_qos_request_list *ipw2100_pm_qos_req;
 
 /* Debugging stuff */
 #ifdef CONFIG_IPW2100_DEBUG
-- 
1.7.1.1

