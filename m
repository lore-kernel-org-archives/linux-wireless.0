Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49867 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1BPM6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 07:58:04 -0500
Received: by ewy5 with SMTP id 5so366160ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 04:58:03 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: trivial: fix SPROM extract warning formatting
Date: Wed, 16 Feb 2011 13:58:25 +0100
Message-Id: <1297861106-18739-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 158449e..127897c 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -641,7 +641,7 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
 		break;
 	default:
 		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
-			   "  revision %d detected. Will extract"
+			   " revision %d detected. Will extract"
 			   " v1\n", out->revision);
 		out->revision = 1;
 		sprom_extract_r123(out, in);
-- 
1.7.1

