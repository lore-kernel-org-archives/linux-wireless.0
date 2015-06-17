Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34876 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbbFQFnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 01:43:07 -0400
Received: by pdbnf5 with SMTP id nf5so30496300pdb.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 22:43:07 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 5/5] staging: wilc1000: add a blank line
Date: Wed, 17 Jun 2015 14:42:36 +0900
Message-Id: <3cb3b7fecf4d28c038b80b07d9375c9839b4b924.1434519635.git.ywhsbliss@gmail.com> (sfid-20150617_074310_595821_BD79A7E3)
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a blank line after struct declaration, WILC_WFI_mon_priv.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3307439..42a017a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -249,6 +249,7 @@ typedef struct {
 struct WILC_WFI_mon_priv {
 	struct net_device *real_ndev;
 };
+
 extern struct net_device *WILC_WFI_devs[];
 
 #endif
-- 
1.9.1

