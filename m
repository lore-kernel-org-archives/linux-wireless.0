Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:52325 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZGUTL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 15:11:59 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, jirislaby@gmail.com
Date: Tue, 21 Jul 2009 22:11:55 +0300
Message-ID: <20090721191154.22374.17349.stgit@tikku>
In-Reply-To: <20090721191136.22374.69017.stgit@tikku>
References: <20090721191136.22374.69017.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Add myself as the maintainer for wl1251 driver.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 18c3f0c..12be899 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6462,6 +6462,15 @@ M:	mitr@volny.cz
 S:	Maintained
 F:	drivers/input/misc/wistron_btns.c
 
+WL1251 WIRELESS DRIVER
+P:	Kalle Valo
+M:	kalle.valo@nokia.com
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
+S:	Maintained
+F:	drivers/net/wireless/wl12xx/wl1251*
+
 WL3501 WIRELESS PCMCIA CARD DRIVER
 P:	Arnaldo Carvalho de Melo
 M:	acme@ghostprotocols.net

