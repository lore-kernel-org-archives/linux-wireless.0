Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51253 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1JGLrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:47:21 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 02/14] ath9k_hw: Update AR9003 initval to improve phase noise
Date: Fri, 7 Oct 2011 17:17:07 +0530
Message-ID: <1317988039-28632-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111007_134724_264293_A218D291)
In-Reply-To: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 02be24e..cc54153 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -190,7 +190,7 @@ static const u32 ar9300_2p2_radio_core[][2] = {
 	{0x00016288, 0x05a20408},
 	{0x0001628c, 0x00038c07},
 	{0x00016290, 0x00000004},
-	{0x00016294, 0x458aa14f},
+	{0x00016294, 0x458a214f},
 	{0x00016380, 0x00000000},
 	{0x00016384, 0x00000000},
 	{0x00016388, 0x00800700},
-- 
1.7.7

