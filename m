Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:32886 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946747AbbHHR6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2015 13:58:46 -0400
Date: Sat, 8 Aug 2015 20:00:07 +0200
From: Daniel Machon <dmachon.dev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Staging: wilc1000: wilc_platform.h: Fixed include guard
 spelling error
Message-ID: <20150808180003.GA6839@gmail.com> (sfid-20150808_195902_477777_83C47FFB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed spelling error

Signed-off-by: Daniel Machon <dmachon.dev@gmail.com>
---
 drivers/staging/wilc1000/wilc_platform.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index d03532c..ccceaae 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -1,5 +1,5 @@
-#ifndef __WILC_platfrom_H__
-#define __WILC_platfrom_H__
+#ifndef __WILC_platform_H__
+#define __WILC_platform_H__
 
 #include <linux/kthread.h>
 #include <linux/semaphore.h>
-- 
2.1.4

