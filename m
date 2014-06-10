Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:46939 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaFJLco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 07:32:44 -0400
Received: by mail-we0-f178.google.com with SMTP id p10so5169479wes.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 04:32:43 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, Paul Bolle <pebolle@tiscali.nl>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [3.16 FIX][PATCH] b43: fix typo in Kconfig (make B43_BUSES_BCMA_AND_SSB the default for real)
Date: Tue, 10 Jun 2014 13:32:05 +0200
Message-Id: <1402399925-23096-1-git-send-email-zajec5@gmail.com> (sfid-20140610_133247_914644_7A4AD0CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index e3f67b8..40fd9b7 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -36,7 +36,7 @@ config B43_SSB
 choice
 	prompt "Supported bus types"
 	depends on B43
-	default B43_BCMA_AND_SSB
+	default B43_BUSES_BCMA_AND_SSB
 
 config B43_BUSES_BCMA_AND_SSB
 	bool "BCMA and SSB"
-- 
1.8.4.5

