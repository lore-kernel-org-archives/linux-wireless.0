Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36134 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2KNG2i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 01:28:38 -0500
To: <rodrigue@qca.qualcomm.com>
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] qca-swiss-army-knife: refresh 9462 initvals
Date: Wed, 14 Nov 2012 11:58:43 +0530
Message-ID: <1352874524-1180-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121114_072842_474073_3F6A6F34)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* update dac_async_fifo
* use peak detection for 5GHz
* Fix wrong peak detector DC offset

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 tools/initvals/ar9462_2p0_initvals.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/initvals/ar9462_2p0_initvals.h b/tools/initvals/ar9462_2p0_initvals.h
index 17094f9..ccc42a7 100644
--- a/tools/initvals/ar9462_2p0_initvals.h
+++ b/tools/initvals/ar9462_2p0_initvals.h
@@ -58,11 +58,11 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcf946220, 0xcf946220, 0xcfd5c782, 0xcfd5c282},
+	{0x00009e3c, 0xcf946222, 0xcf946222, 0xcfd5c782, 0xcfd5c282},
 	{0x00009e44, 0x62321e27, 0x62321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
-	{0x0000a204, 0x013187c0, 0x013187c4, 0x013187c4, 0x013187c0},
+	{0x0000a204, 0x01318fc0, 0x01318fc4, 0x01318fc4, 0x01318fc0},
 	{0x0000a208, 0x00000104, 0x00000104, 0x00000004, 0x00000004},
 	{0x0000a22c, 0x01026a2f, 0x01026a27, 0x01026a2f, 0x01026a2f},
 	{0x0000a230, 0x0000400a, 0x00004014, 0x00004016, 0x0000400b},
@@ -78,7 +78,7 @@ static const u32 ar9462_2p0_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00058d18, 0x00058d18, 0x00058d18, 0x00058d18},
 	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
-- 
1.8.0

