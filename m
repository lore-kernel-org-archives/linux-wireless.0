Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:36389 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaGMJni (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 05:43:38 -0400
Received: by mail-we0-f180.google.com with SMTP id k48so1960064wev.25
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 02:43:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/13] staging: vt6656: dead code remove typedef enum tagCMD_STATUS
Date: Sun, 13 Jul 2014 10:42:46 +0100
Message-Id: <1405244573-10978-6-git-send-email-tvboxspy@gmail.com> (sfid-20140713_114352_130603_0A568B85)
In-Reply-To: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
References: <1405244573-10978-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index f42270b..a2943ab 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -46,16 +46,6 @@ enum vnt_cmd {
 
 #define CMD_Q_SIZE              32
 
-typedef enum tagCMD_STATUS {
-
-    CMD_STATUS_SUCCESS = 0,
-    CMD_STATUS_FAILURE,
-    CMD_STATUS_RESOURCES,
-    CMD_STATUS_TIMEOUT,
-    CMD_STATUS_PENDING
-
-} CMD_STATUS, *PCMD_STATUS;
-
 /* Command state */
 enum vnt_cmd_state {
 	WLAN_CMD_INIT_MAC80211_START,
-- 
1.9.1

