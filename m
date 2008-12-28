Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:46162 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYL1SnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 13:43:21 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH] at76_usb: mention mac80211 port in TODO file
To: gregkh@suse.de
Cc: linux-wireless@vger.kernel.org
Date: Sun, 28 Dec 2008 20:32:33 +0200
Message-ID: <20081228183233.15512.10965.stgit@tikku> (sfid-20081228_194324_788473_579B3FB9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

at76_usb has actually been already ported to use mac80211. Update the TODO
file to reflect this.

Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
---

 drivers/staging/at76_usb/TODO |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/at76_usb/TODO b/drivers/staging/at76_usb/TODO
index 6911ca7..0c7ed21 100644
--- a/drivers/staging/at76_usb/TODO
+++ b/drivers/staging/at76_usb/TODO
@@ -1,2 +1,7 @@
-rewrite the driver to use the proper in-kernel wireless stack
-instead of using its own.
+Fix the mac80211 port of at76_usb (the proper in-kernel wireless
+stack) and get it included to the mainline. Patches available here:
+
+http://git.kernel.org/?p=linux/kernel/git/linville/wireless-legacy.git;a=shortlog;h=at76
+
+Contact Kalle Valo <kalle.valo@iki.fi> and linux-wireless list
+<linux-wireless@vger.kernel.org> for more information.

