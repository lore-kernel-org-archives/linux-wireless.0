Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:48207 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3GVJcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 05:32:25 -0400
Subject: [PATCH 1/2] MAINTAINERS: add ath10k
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org
Date: Mon, 22 Jul 2013 12:32:20 +0300
Message-ID: <20130722093220.26562.14270.stgit@localhost6.localdomain6> (sfid-20130722_113228_117949_93CFD8BF)
In-Reply-To: <20130722093113.26562.11543.stgit@localhost6.localdomain6>
References: <20130722093113.26562.11543.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I forgot to add an entry to MAINTAINERS when submitting the driver.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..44626b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6719,6 +6719,14 @@ T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
 F:	drivers/media/tuners/qt1010*
 
+QUALCOMM ATHEROS ATH10K WIRELESS DRIVER
+M:	Kalle Valo <kvalo@qca.qualcomm.com>
+L:	ath10k@lists.infradead.org
+W:	http://wireless.kernel.org/en/users/Drivers/ath10k
+T:	git git://github.com/kvalo/ath.git
+S:	Supported
+F:	drivers/net/wireless/ath/ath10k/
+
 QUALCOMM HEXAGON ARCHITECTURE
 M:	Richard Kuo <rkuo@codeaurora.org>
 L:	linux-hexagon@vger.kernel.org

