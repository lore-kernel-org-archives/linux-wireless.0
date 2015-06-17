Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35600 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbbFQFmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 01:42:55 -0400
Received: by pacyx8 with SMTP id yx8so27157878pac.2
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 22:42:55 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 2/5] staging: wilc1000: remove unnecessary blank line.
Date: Wed, 17 Jun 2015 14:42:33 +0900
Message-Id: <16fc5e141ea7886195226b60953672a48025ae33.1434519635.git.ywhsbliss@gmail.com> (sfid-20150617_074302_401462_2DCFE0AF)
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line which is not necesssary after an open
brace.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index a8b1501..7f58551 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -57,7 +57,6 @@ enum stats_flags {
 };
 
 struct WILC_WFI_stats {
-
 	unsigned long rx_packets;
 	unsigned long tx_packets;
 	unsigned long rx_bytes;
-- 
1.9.1

