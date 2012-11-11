Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64373 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2KKPhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 10:37:21 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3643383wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 07:37:20 -0800 (PST)
Message-ID: <1352648234.6460.14.camel@canaries32-MCP7A> (sfid-20121111_163724_534030_919A4895)
Subject: [PATCH 07/14] staging: vt6656: 64 bit fixes: int.h replaced DWORD
 with u32
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 15:37:14 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes size of long issues.

Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>

---
 drivers/staging/vt6656/int.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/int.h b/drivers/staging/vt6656/int.h
index 3734e2c..5d8faf9 100644
--- a/drivers/staging/vt6656/int.h
+++ b/drivers/staging/vt6656/int.h
@@ -48,8 +48,8 @@ typedef struct tagSINTData {
 	BYTE byTSR3;
 	BYTE byPkt3;
 	WORD wTime3;
-	DWORD dwLoTSF;
-	DWORD dwHiTSF;
+	u32 dwLoTSF;
+	u32 dwHiTSF;
 	BYTE byISR0;
 	BYTE byISR1;
 	BYTE byRTSSuccess;
-- 
1.8.0



