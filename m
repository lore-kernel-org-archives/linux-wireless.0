Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932508AbdA0MTb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 07:19:31 -0500
Received: from potku.adurom.net.com (a88-115-187-87.elisa-laajakaista.fi [88.115.187.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 385AC607A2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jan 2017 12:19:29 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] MAINTAINERS: ath9k-devel is closed
Date: Fri, 27 Jan 2017 14:19:25 +0200
Message-Id: <1485519565-21402-1-git-send-email-kvalo@codeaurora.org> (sfid-20170127_132231_929154_C503F3FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k-devel list is now closed, only linux-wireless should be used.

Reported-by: Michael Renzmann <mrenzmann@madwifi-project.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cfff2c9e3d94..d7699d5b5863 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10169,7 +10169,6 @@ F:	drivers/media/tuners/qt1010*
 QUALCOMM ATHEROS ATH9K WIRELESS DRIVER
 M:	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
 L:	linux-wireless@vger.kernel.org
-L:	ath9k-devel@lists.ath9k.org
 W:	http://wireless.kernel.org/en/users/Drivers/ath9k
 S:	Supported
 F:	drivers/net/wireless/ath/ath9k/
-- 
2.7.4
