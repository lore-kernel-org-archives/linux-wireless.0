Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1KYSk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:40:56 -0500
Received: by bke11 with SMTP id 11so4712560bke.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:40:55 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 02/12] ath5k: Add TXNOFRM to INT_TX_ALL
Date: Fri, 25 Nov 2011 20:40:21 +0200
Message-Id: <1322246431-10825-3-git-send-email-mickflemm@gmail.com> (sfid-20111125_194059_861003_536C4D46)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add TXNOFRM to INT_TX_ALL since it's a TX interrupt too.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 0f42a57..b8abdbc 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -856,6 +856,7 @@ enum ath5k_int {
 	AR5K_INT_TX_ALL = AR5K_INT_TXOK
 		| AR5K_INT_TXDESC
 		| AR5K_INT_TXERR
+		| AR5K_INT_TXNOFRM
 		| AR5K_INT_TXEOL
 		| AR5K_INT_TXURN,
 
-- 
1.7.8.rc3

