Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:45384 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751896AbXKST2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 14:28:32 -0500
Date: Mon, 19 Nov 2007 20:27:46 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
Subject: [PATCH v2] libertas: add Dan Williams as maintainer
Message-ID: <20071119202746.475f0469@morte> (sfid-20071119_192836_691462_84F4A154)
In-Reply-To: <1195493292.3248.6.camel@localhost.localdomain>
References: <20071117023020.0a164e90@morte>
 <20071117165551.GA5817@tuxdriver.com>
 <20071117181153.480d75d8@morte>
 <1195493292.3248.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add Dan Williams as maintainer for libertas driver.


Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Dan Williams <dcbw@redhat.com>

---

diff --git a/MAINTAINERS b/MAINTAINERS
index 18b7c8e..d416260 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2513,6 +2504,12 @@ M:	mtk.manpages@gmail.com
 W:	ftp://ftp.kernel.org/pub/linux/docs/manpages
 S:	Maintained
 
+MARVELL LIBERTAS WIRELESS DRIVER
+P:	Dan Williams
+M:	dcbw@redhat.com
+L:	libertas-dev@lists.infradead.org
+S:	Maintained
+
 MARVELL MV643XX ETHERNET DRIVER
 P:	Dale Farnsworth
 M:	dale@farnsworth.org


-- 
Ciao
Stefano
