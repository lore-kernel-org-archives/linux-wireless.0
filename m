Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:49850 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab0ANPqp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 10:46:45 -0500
Received: by fxm25 with SMTP id 25so178468fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jan 2010 07:46:44 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2 resend] b43: N-PHY: follow kernel coding style for struct
 declaration
Date: Thu, 14 Jan 2010 16:46:42 +0100
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6i4r4ge9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---

Whoops, wrong patch attached previously

---
  drivers/net/wireless/b43/phy_n.c |    7 ++++++-
  1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index d0a0ce9..fbdabfe 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -30,7 +30,12 @@
  #include "tables_nphy.h"


-struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; };
+struct nphy_txgains {
+	u16 txgm[2];
+	u16 pga[2];
+	u16 pad[2];
+	u16 ipa[2];
+};

  struct nphy_iqcal_params {
  	u16 txgm;
-- 
1.6.4.2

