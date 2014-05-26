Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:60511 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaEZNAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:20 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so4332914wiw.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:19 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/11] staging: vt6656: Fix CARDvCalculateOFDMRParameter static warning
Date: Mon, 26 May 2014 13:59:08 +0100
Message-Id: <1401109148-3593-11-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150033_269199_A9323E5F)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix  warning: symbol 'CARDvCalculateOFDMRParameter' was not declared. Should it be static?

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 06f8b00..5ad0a98 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -197,7 +197,7 @@ static u16 swGetOFDMControlRate(struct vnt_private *priv, u16 rate_idx)
  * Return Value: none
  *
  */
-void CARDvCalculateOFDMRParameter(u16 rate, u8 bb_type,
+static void CARDvCalculateOFDMRParameter(u16 rate, u8 bb_type,
 					u8 *tx_rate, u8 *rsv_time)
 {
 
-- 
1.9.1

