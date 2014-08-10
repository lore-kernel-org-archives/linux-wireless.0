Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40815 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaHJOsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:07 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so7463568wgh.25
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:48:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 9/9] staging: vt6655: remove typedef from struct vnt_private
Date: Sun, 10 Aug 2014 15:47:03 +0100
Message-Id: <1407682023-2865-9-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164914_899344_56545957)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 878b6d2..e1a322f 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -337,8 +337,7 @@ typedef struct __device_opt {
 	u32         flags;
 } OPTIONS, *POPTIONS;
 
-/* TODO Convert all functions to struct vnt_private and remove typedef */
-typedef struct vnt_private {
+struct vnt_private {
 	struct vnt_private *next;
 	struct vnt_private *prev;
 
@@ -743,7 +742,7 @@ typedef struct vnt_private {
 
 	struct iw_statistics	wstats;		// wireless stats
 	bool bCommit;
-} DEVICE_INFO, *PSDevice;
+};
 
 static inline bool device_get_ip(struct vnt_private *pInfo)
 {
-- 
1.9.1

