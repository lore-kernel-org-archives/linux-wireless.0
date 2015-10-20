Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14445 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbJTPN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 11:13:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-firmware@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH v2] ath10k: add notice.txt references to WHENCE
Date: Tue, 20 Oct 2015 18:13:29 +0300
Message-ID: <1445354009-20338-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20151020_171401_906043_16E90EA3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to make sure that the notice files get automatically included.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 WHENCE |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/WHENCE b/WHENCE
index 9b7e8e8526aa..ded2e7ad161b 100755
--- a/WHENCE
+++ b/WHENCE
@@ -2393,17 +2393,22 @@ Driver: ath10k - Qualcomm Atheros support for QCA988x family of chips
 File: ath10k/QCA988X/hw2.0/board.bin
 File: ath10k/QCA988X/hw2.0/firmware-4.bin
 Version: 10.2.4.45
+Licence: ath10k/QCA988X/hw2.0/notice_ath10k_firmware-4.txt
 File: ath10k/QCA988X/hw2.0/firmware-5.bin
 Version: 10.2.4.70.9-2
+Licence: ath10k/QCA988X/hw2.0/notice_ath10k_firmware-5.txt
 File: ath10k/QCA6174/hw2.1/board.bin
 File: ath10k/QCA6174/hw2.1/firmware-5.bin
 Version: WLAN.RM.1.1-00141
+Licence: ath10k/QCA6174/hw2.1/notice_ath10k_firmware-5.txt
 File: ath10k/QCA6174/hw3.0/board.bin
 File: ath10k/QCA6174/hw3.0/firmware-4.bin
 Version: WLAN.RM.2.0-00180-QCARMSWPZ-1
+Licence: ath10k/QCA6174/hw3.0/notice_ath10k_firmware-4.txt
 File: ath10k/QCA99X0/hw2.0/board.bin
 File: ath10k/QCA99X0/hw2.0/firmware-5.bin
 Version: 10.4.1.00030-1
+Licence: ath10k/QCA99X0/hw2.0/notice_ath10k_firmware-5.txt
 
 Licence: Redistributable. See LICENSE.QualcommAtheros_ath10k for details
 
-- 
1.7.9.5

