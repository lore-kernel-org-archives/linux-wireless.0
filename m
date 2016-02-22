Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:20600 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbcBVKTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 05:19:31 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V4 15/24] staging: wilc1000: coreconfigurator.c: removes unnecessary log messages
Date: Mon, 22 Feb 2016 19:14:22 +0900
Message-ID: <1456136071-10502-16-git-send-email-leo.kim@atmel.com> (sfid-20160222_111939_493982_23A41121)
In-Reply-To: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
References: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log messages.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 3a76586..25dc108 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -284,10 +284,8 @@ s32 wilc_parse_network_info(u8 *msg_buffer,
 
 	msg_type = msg_buffer[0];
 
-	if ('N' != msg_type) {
-		PRINT_ER("Received Message format incorrect.\n");
+	if ('N' != msg_type)
 		return -EFAULT;
-	}
 
 	msg_id = msg_buffer[1];
 	msg_len = MAKE_WORD16(msg_buffer[2], msg_buffer[3]);
-- 
1.9.1

