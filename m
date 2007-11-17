Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42651 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753686AbXKQBbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 20:31:21 -0500
Date: Sat, 17 Nov 2007 02:30:20 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: list as orphan in MAINTAINERS
Message-ID: <20071117023020.0a164e90@morte> (sfid-20071117_013124_317278_7DE6A23B)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

List the Marvell Libertas wireless driver as orphan in the MAINTAINERS
file.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 18b7c8e..76bfb9a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2513,6 +2513,9 @@ M:	mtk.manpages@gmail.com
 W:	ftp://ftp.kernel.org/pub/linux/docs/manpages
 S:	Maintained
 
+MARVELL LIBERTAS WIRELESS DRIVER
+S:	Orphan
+
 MARVELL MV643XX ETHERNET DRIVER
 P:	Dale Farnsworth
 M:	dale@farnsworth.org


-- 
Ciao
Stefano
