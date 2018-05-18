Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751413AbeERQIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 12:08:20 -0400
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF3906021A
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2018 16:08:18 +0000 (UTC)
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: change Kalle as wcn36xx maintainer
Date: Fri, 18 May 2018 19:08:13 +0300
Message-Id: <1526659693-32546-3-git-send-email-kvalo@codeaurora.org> (sfid-20180518_180823_896171_01298875)
In-Reply-To: <1526659693-32546-1-git-send-email-kvalo@codeaurora.org>
References: <1526659693-32546-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eugene hasn't worked on wcn36xx for some time now.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5dace1734086..c1b15dde5a46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11702,7 +11702,7 @@ S:	Maintained
 F:	drivers/media/platform/qcom/venus/
 
 QUALCOMM WCN36XX WIRELESS DRIVER
-M:	Eugene Krasnikov <k.eugene.e@gmail.com>
+M:	Kalle Valo <kvalo@codeaurora.org>
 L:	wcn36xx@lists.infradead.org
 W:	http://wireless.kernel.org/en/users/Drivers/wcn36xx
 T:	git git://github.com/KrasnikovEugene/wcn36xx.git
-- 
2.7.4
