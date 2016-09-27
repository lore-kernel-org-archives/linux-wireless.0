Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:43266 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934887AbcI0PtT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 11:49:19 -0400
Date: Tue, 27 Sep 2016 18:42:58 +0300
From: Jouni Malinen <j@w1.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] hostap: Mark the Host AP driver obsolete
Message-ID: <20160927154258.GA6443@w1.fi> (sfid-20160927_174949_918143_17B0E5E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is old code for old hardware and it is not really accurate to claim
this to be maintained anymore. Change the status to "Obsolete" to make
it clearer that minor cleanup and other unnecessary changes from
automated tools is not necessarily beneficial and has larger risk of
breaking something without being quickly noticed due to lack of testing.

In addition, remove the old mailing list that does not work anymore and
point the web-page to a more accurate URL.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 MAINTAINERS | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index efd69c76..20de5f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5593,10 +5593,9 @@ F:	Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
 
 HOST AP DRIVER
 M:	Jouni Malinen <j@w1.fi>
-L:	hostap@shmoo.com (subscribers-only)
 L:	linux-wireless@vger.kernel.org
-W:	http://hostap.epitest.fi/
-S:	Maintained
+W:	http://w1.fi/hostap-driver.html
+S:	Obsolete
 F:	drivers/net/wireless/intersil/hostap/
 
 HP COMPAQ TC1100 TABLET WMI EXTRAS DRIVER
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
