Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8322 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbcFNFcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 01:32:31 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix a typo in spectral code commments
Date: Tue, 14 Jun 2016 11:03:54 +0530
Message-ID: <1465882434-594-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160614_073239_387324_39F1845A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Found this obvious typo while going through the spectral
code design in ath10k

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/spectral.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/spectral.c b/drivers/net/wireless/ath/ath10k/spectral.c
index 4671cfb..4510906 100644
--- a/drivers/net/wireless/ath/ath10k/spectral.c
+++ b/drivers/net/wireless/ath/ath10k/spectral.c
@@ -101,7 +101,7 @@ int ath10k_spectral_process_fft(struct ath10k *ar,
 		break;
 	case 80:
 		/* TODO: As experiments with an analogue sender and various
-		 * configuaritions (fft-sizes of 64/128/256 and 20/40/80 Mhz)
+		 * configurations (fft-sizes of 64/128/256 and 20/40/80 Mhz)
 		 * show, the particular configuration of 80 MHz/64 bins does
 		 * not match with the other smaples at all. Until the reason
 		 * for that is found, don't report these samples.
-- 
1.7.9.5

