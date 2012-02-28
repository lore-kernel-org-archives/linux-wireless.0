Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6942 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab2B1BF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:05:58 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 4/7] compat: remove dubious clean at install target
Date: Mon, 27 Feb 2012 17:05:38 -0800
Message-ID: <1330391141-19909-5-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_024255_924701_6B8BFF5E)
In-Reply-To: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

Not sure why this was added, this is a big typo.

Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 423d1ed..2f47e3f 100644
--- a/Makefile
+++ b/Makefile
@@ -57,7 +57,6 @@ install: modules
 	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) $(KMODDIR_ARG) $(KMODPATH_ARG) \
 		modules_install
 	depmod -a
-	$(MAKE) -C $(KLIB_BUILD) M=$(PWD) clean
 
 $(COMPAT_AUTOCONF): ;
 
-- 
1.7.4.15.g7811d

