Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43692 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1IMHVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:21:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Naveen Singh <nvesing@qca.qualcomm.com>
Subject: [PATCH] MAINTAINERS: update ath6kl
Date: Tue, 13 Sep 2011 10:21:25 +0300
Message-Id: <1315898485-8441-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110913_092138_035951_0C7D9C8A)
In-Reply-To: <4E6F0390.4060704@qca.qualcomm.com>
References: <4E6F0390.4060704@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not in staging anymore and I'm the current maintainer.

Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: Naveen Singh <nvesing@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---

John, please take this directly. Hopefully less conflicts that way.

 MAINTAINERS |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d4f2532..d8b5d05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1246,6 +1246,14 @@ W:	http://wireless.kernel.org/en/users/Drivers/ath5k
 S:	Maintained
 F:	drivers/net/wireless/ath/ath5k/
 
+ATHEROS ATH6KL WIRELESS DRIVER
+M:	Kalle Valo <kvalo@qca.qualcomm.com>
+L:	linux-wireless@vger.kernel.org
+W:	http://wireless.kernel.org/en/users/Drivers/ath6kl
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath6kl.git
+S:	Supported
+F:	drivers/net/wireless/ath/ath6kl/
+
 ATHEROS ATH9K WIRELESS DRIVER
 M:	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
 M:	Jouni Malinen <jouni@qca.qualcomm.com>
@@ -6152,12 +6160,6 @@ M:	Jakub Schmidtke <sjakub@gmail.com>
 S:	Odd Fixes
 F:	drivers/staging/asus_oled/
 
-STAGING - ATHEROS ATH6KL WIRELESS DRIVER
-M:	Luis R. Rodriguez <mcgrof@gmail.com>
-M:	Naveen Singh <nsingh@atheros.com>
-S:	Odd Fixes
-F:	drivers/staging/ath6kl/
-
 STAGING - COMEDI
 M:	Ian Abbott <abbotti@mev.co.uk>
 M:	Mori Hess <fmhess@users.sourceforge.net>
-- 
1.7.1

