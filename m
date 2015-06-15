Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36458 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbFOKmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 06:42:40 -0400
Received: by pabqy3 with SMTP id qy3so63153996pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jun 2015 03:42:39 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 1/2] staging: wilc1000: remove multiple blank lines.
Date: Mon, 15 Jun 2015 19:42:31 +0900
Message-Id: <f6284cd2afe7096c38741f6391d150a2c2dd198a.1434361814.git.ywhsbliss@gmail.com> (sfid-20150615_124243_324964_8970FCB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the warnings for multiple blank lines reported by checkpatch.pl.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/coreconfigsimulator.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigsimulator.h b/drivers/staging/wilc1000/coreconfigsimulator.h
index 25e3c2c..c4f32f0 100644
--- a/drivers/staging/wilc1000/coreconfigsimulator.h
+++ b/drivers/staging/wilc1000/coreconfigsimulator.h
@@ -8,13 +8,10 @@
  *  @version	1.0
  */
 
-
 #ifndef CORECONFIGSIMULATOR_H
 #define CORECONFIGSIMULATOR_H
 
-
 extern s32 CoreConfigSimulatorInit (void);
 extern s32 CoreConfigSimulatorDeInit (void);
 
-
-#endif
\ No newline at end of file
+#endif
-- 
1.9.1

