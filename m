Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53523 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793Ab0GUT1W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 15:27:22 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: refresh patch
Date: Wed, 21 Jul 2010 21:27:14 +0200
Message-Id: <1279740434-13086-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/28-pm-qos-params.patch |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/patches/28-pm-qos-params.patch b/patches/28-pm-qos-params.patch
index 438bdd8..a6aab68 100644
--- a/patches/28-pm-qos-params.patch
+++ b/patches/28-pm-qos-params.patch
@@ -21,9 +21,9 @@ little wierd.
  #define DRV_COPYRIGHT	"Copyright(c) 2003-2006 Intel Corporation"
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
- struct pm_qos_request_list ipw2100_pm_qos_req;
+ static struct pm_qos_request_list ipw2100_pm_qos_req;
 +#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
-+struct pm_qos_request_list *ipw2100_pm_qos_req;
++static struct pm_qos_request_list *ipw2100_pm_qos_req;
 +#endif
  
  /* Debugging stuff */
-- 
1.7.0.4

