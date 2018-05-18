Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50768 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbeERQIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 12:08:20 -0400
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E6F8F602B8
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 16:08:17 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] MAINTAINERS: change Kalle as ath.ko maintainer
Date: Fri, 18 May 2018 19:08:12 +0300
Message-Id: <1526659693-32546-2-git-send-email-kvalo@codeaurora.org> (sfid-20180518_180826_889643_49EC4F15)
In-Reply-To: <1526659693-32546-1-git-send-email-kvalo@codeaurora.org>
References: <1526659693-32546-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis hasn't worked on ath.ko for some time now.

Acked-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4be9ff892ec0..5dace1734086 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2330,7 +2330,7 @@ F:	drivers/gpio/gpio-ath79.c
 F:	Documentation/devicetree/bindings/gpio/gpio-ath79.txt
 
 ATHEROS ATH GENERIC UTILITIES
-M:	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
+M:	Kalle Valo <kvalo@codeaurora.org>
 L:	linux-wireless@vger.kernel.org
 S:	Supported
 F:	drivers/net/wireless/ath/*
-- 
2.7.4
