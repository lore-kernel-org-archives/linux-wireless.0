Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4657 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 026/119] staging: brcm80211: delete empty
 brcmfmac/README file
Date: Wed, 29 Jun 2011 16:46:50 -0700
Message-ID: <1309391303-22741-27-git-send-email-frankyl@broadcom.com> (sfid-20110630_015001_981730_70FEF4A2)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

brcm80211/brcmfmac/README contents were move to brcm80211/README previously,
but this empty file is still around.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/README |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmfmac/README

diff --git a/drivers/staging/brcm80211/brcmfmac/README b/drivers/staging/brcm80211/brcmfmac/README
deleted file mode 100644
index 139597f..0000000
--- a/drivers/staging/brcm80211/brcmfmac/README
+++ /dev/null
@@ -1,2 +0,0 @@
-
-
-- 
1.7.1


