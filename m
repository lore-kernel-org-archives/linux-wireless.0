Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab1JJFvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 01:51:44 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 01/13] ath9k_hw: Updated ar9003 initval table for AR9380
Date: Mon, 10 Oct 2011 11:21:06 +0530
Message-ID: <1318225878-7283-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111010_075148_077626_B951CA9A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ar9003 table is updated to increase XLNA BIAS
output driver strengh.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 08e9341..02be24e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -24,11 +24,11 @@ static const u32 ar9300_2p2_radio_postamble[][5] = {
 	{0x0001609c, 0x0dd08f29, 0x0dd08f29, 0x0b283f31, 0x0b283f31},
 	{0x000160ac, 0xa4653c00, 0xa4653c00, 0x24652800, 0x24652800},
 	{0x000160b0, 0x03284f3e, 0x03284f3e, 0x05d08f20, 0x05d08f20},
-	{0x0001610c, 0x08000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0001610c, 0xc8000000, 0xc0000000, 0xc0000000, 0xc0000000},
 	{0x00016140, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
-	{0x0001650c, 0x08000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0001650c, 0xc8000000, 0xc0000000, 0xc0000000, 0xc0000000},
 	{0x00016540, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
-	{0x0001690c, 0x08000000, 0x00000000, 0x00000000, 0x00000000},
+	{0x0001690c, 0xc8000000, 0xc0000000, 0xc0000000, 0xc0000000},
 	{0x00016940, 0x10804008, 0x10804008, 0x50804008, 0x50804008},
 };
 
-- 
1.7.7

