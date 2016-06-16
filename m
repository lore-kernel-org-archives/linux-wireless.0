Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16089 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbcFPQbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 12:31:22 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: Fix some typo in spectral code commments
Date: Thu, 16 Jun 2016 21:43:48 +0530
Message-ID: <1466093628-10653-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160616_183125_178854_7C0B3395)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Found this obvious typo while going through the spectral
code design in ath10k

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/spectral.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index 4671cfb..7d9b0da 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -101,9 +101,9 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 		break;
 	case 80:
 		/* TODO: As experiments with an analogue sender and various
-		 * configuaritions (fft-sizes of 64/128/256 and 20/40/80 Mhz)
+		 * configurations (fft-sizes of 64/128/256 and 20/40/80 Mhz)
 		 * show, the particular configuration of 80 MHz/64 bins does
-		 * not match with the other smaples at all. Until the reason
+		 * not match with the other samples at all. Until the reason
 		 * for that is found, don't report these samples.
 		 */
 		if (bin_len == 64)
-- 
1.9.1

