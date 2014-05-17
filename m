Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33356 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaEQIxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:21 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so5801544wgh.23
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:20 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 21/22] staging: vt6656: vnt_private remove dead variables.
Date: Sat, 17 May 2014 09:50:38 +0100
Message-Id: <1400316639-4430-21-git-send-email-tvboxspy@gmail.com> (sfid-20140517_112148_893233_D4FD43B3)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

byBBCR4d
byBBCRc9
byBBCR88
byBBCR09

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index a8637ec..ee3fb0b 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -672,12 +672,6 @@ struct vnt_private {
 
 	int bRadioCmd;
 
-	/* BaseBand Loopback Use */
-	u8 byBBCR4d;
-	u8 byBBCRc9;
-	u8 byBBCR88;
-	u8 byBBCR09;
-
 	/* command timer */
 	struct delayed_work run_command_work;
 	/* One second callback */
-- 
1.9.1

