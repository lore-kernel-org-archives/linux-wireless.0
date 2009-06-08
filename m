Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:44167 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbZFHTQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 15:16:34 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 3/3] stlc45xx: add TODO
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 08 Jun 2009 22:09:17 +0300
Message-ID: <20090608190916.25081.60779.stgit@tikku>
In-Reply-To: <20090608190901.25081.26264.stgit@tikku>
References: <20090608190901.25081.26264.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

p54spi will in future replace this driver, mention that in TODO file.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/staging/stlc45xx/TODO |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/stlc45xx/TODO

diff --git a/drivers/staging/stlc45xx/TODO b/drivers/staging/stlc45xx/TODO
new file mode 100644
index 0000000..15f55f5
--- /dev/null
+++ b/drivers/staging/stlc45xx/TODO
@@ -0,0 +1,5 @@
+p54spi driver will replace this driver, please work on that instead.
+
+http://wireless.kernel.org/en/users/Drivers/p54
+
+stlc45xx can be removed as soon as p54spi has all the features implemented.

