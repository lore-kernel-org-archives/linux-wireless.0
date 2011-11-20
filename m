Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47531 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab1KTH5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 02:57:34 -0500
Received: by bke11 with SMTP id 11so5187743bke.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Nov 2011 23:57:33 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 03/13] ath5k: Add TXNOFRM to INT_TX_ALL
Date: Sun, 20 Nov 2011 09:56:18 +0200
Message-Id: <1321775788-12520-4-git-send-email-mickflemm@gmail.com> (sfid-20111120_085737_707096_D3D69E9E)
In-Reply-To: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
References: <1321775788-12520-1-git-send-email-mickflemm@gmail.com>
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
1.7.8.rc1

