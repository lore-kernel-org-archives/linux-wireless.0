Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35723 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbIPLMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:12:03 -0400
Received: by pacfv12 with SMTP id fv12so210910597pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:12:03 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/10] staging: wilc1000: remove WILC_TIME typedef
Date: Wed, 16 Sep 2015 20:11:33 +0900
Message-Id: <1442401895-7463-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131214_853502_D2BCC52D)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes WILC_TIME typedef that is not used anymore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_platform.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index 5c867ec..b763616 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -33,8 +33,6 @@ typedef struct __MessageQueue_struct {
 
 
 
-/*Time represented in 64 bit format*/
-typedef time_t WILC_Time;
 
 
 /*******************************************************************
-- 
2.5.1

