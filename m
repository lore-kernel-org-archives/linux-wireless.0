Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47963 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755400Ab0KLSsB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 13:48:01 -0500
Message-ID: <4CDD8BDD.7050903@openwrt.org>
Date: Fri, 12 Nov 2010 19:47:57 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] compat: fix a typo in pm_qos_update_request for 2.6.35
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -83,7 +83,7 @@ struct pm_qos_request_list {
     } while (0)
 
 #define pm_qos_update_request(_req, _value)				\
-	pm_qos_update_request((_req)->request, (_value)
+	pm_qos_update_request((_req)->request, (_value))
 
 #define pm_qos_remove_request(_req)					\
 	pm_qos_remove_request((_req)->request)
