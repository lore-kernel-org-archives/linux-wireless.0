Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47043 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaEXNiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2014 09:38:24 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so5932676wgh.11
        for <linux-wireless@vger.kernel.org>; Sat, 24 May 2014 06:38:23 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 14/14] staging: vt6656: CARDvCalculateOFDMRParameter fix indentation rsv_time
Date: Sat, 24 May 2014 14:37:10 +0100
Message-Id: <1400938630-2850-14-git-send-email-tvboxspy@gmail.com> (sfid-20140524_153833_084555_681F1838)
In-Reply-To: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
References: <1400938630-2850-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In patch
staging: vt6656 camel case clean up CARDvCalculateOFDMRParameter
rsv_time is indented incorrectly.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 5a65f75..ce069c9 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -256,7 +256,7 @@ void CARDvCalculateOFDMRParameter(u16 rate, u8 bb_type,
 			*rsv_time = 4;
 		} else {
 			*tx_rate = 0x88;
-		*rsv_time = 10;
+			*rsv_time = 10;
 		}
 		break;
 	case RATE_54M:
-- 
1.9.1

