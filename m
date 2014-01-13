Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49320 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbaAMQRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 11:17:11 -0500
Received: by mail-wg0-f42.google.com with SMTP id l18so2949953wgh.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 08:17:10 -0800 (PST)
Message-ID: <1389629824.2590.0.camel@canaries32-MCP7A> (sfid-20140113_171720_495848_8B22420D)
Subject: [PATCH 1/6] staging: vt6656: sparse fixes: dpc.c missing dpc.h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Jan 2014 16:17:04 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sparse warnings
dpc.c:249:5: warning: symbol 'RXbBulkInProcessData' was not declared. Should it be static?
dpc.c:1295:6: warning: symbol 'RXvWorkItem' was not declared. Should it be static?
dpc.c:1321:6: warning: symbol 'RXvFreeRCB' was not declared. Should it be static?
dpc.c:1356:6: warning: symbol 'RXvMngWorkItem' was not declared. Should it be static?

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/dpc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/dpc.c b/drivers/staging/vt6656/dpc.c
index 7b050e9..eca04c0 100644
--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -38,6 +38,7 @@
  *
  */
 
+#include "dpc.h"
 #include "device.h"
 #include "rxtx.h"
 #include "tether.h"
-- 
1.8.5.2


