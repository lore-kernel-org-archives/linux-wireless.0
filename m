Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:36788 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753088AbeAQUFu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 15:05:50 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codaurora.org>
Subject: [PATCH] MAINTAINERS: wireless: update wil6210 maintainer entry
Date: Wed, 17 Jan 2018 22:05:42 +0200
Message-Id: <1516219542-6450-1-git-send-email-merez@codeaurora.org> (sfid-20180117_210557_421746_FA82CF75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wil6210 maintainer email and mail list has changed, hence update
its MAINTAINERS entry accordingly.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 129c591..bdaba61 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14760,9 +14760,9 @@ S:	Maintained
 F:	drivers/hid/hid-wiimote*
 
 WILOCITY WIL6210 WIRELESS DRIVER
-M:	Maya Erez <qca_merez@qca.qualcomm.com>
+M:	Maya Erez <merez@codeaurora.org>
 L:	linux-wireless@vger.kernel.org
-L:	wil6210@qca.qualcomm.com
+L:	wil6210@qti.qualcomm.com
 S:	Supported
 W:	http://wireless.kernel.org/en/users/Drivers/wil6210
 F:	drivers/net/wireless/ath/wil6210/
-- 
1.9.1
