Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50746 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeERQIS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 12:08:18 -0400
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D78846021A
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 16:08:16 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] MAINTAINERS: update Kalle's email address
Date: Fri, 18 May 2018 19:08:11 +0300
Message-Id: <1526659693-32546-1-git-send-email-kvalo@codeaurora.org> (sfid-20180518_180821_730198_C4E96DCA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I switched to use my codeaurora.org address.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d21f2f74578..4be9ff892ec0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2345,7 +2345,7 @@ S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
 ATHEROS ATH6KL WIRELESS DRIVER
-M:	Kalle Valo <kvalo@qca.qualcomm.com>
+M:	Kalle Valo <kvalo@codeaurora.org>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath6kl
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
@@ -11651,7 +11651,7 @@ S:	Maintained
 F:	drivers/media/tuners/qt1010*
 
 QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
-M:	Kalle Valo <kvalo@qca.qualcomm.com>
+M:	Kalle Valo <kvalo@codeaurora.org>
 L:	ath10k@lists.infradead.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath10k
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
-- 
2.7.4
