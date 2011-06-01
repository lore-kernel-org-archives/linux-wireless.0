Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2226 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 32/83] staging: brcm80211: remove extern variable
 definitions in bcmsrom.c
Date: Wed, 1 Jun 2011 13:45:17 +0200
Message-ID: <1306928768-7501-32-git-send-email-rvossen@broadcom.com> (sfid-20110601_134704_229506_D90903FF)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The file bcmsrom.c defined two global externals. As these were also
not used these have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index 487e731..a1a2fc5 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -64,8 +64,6 @@ typedef struct varbuf {
 	char *buf;		/* pointer to current position */
 	unsigned int size;	/* current (residual) size in bytes */
 } varbuf_t;
-extern char *_vars;
-extern uint _varsz;
 
 /* Assumptions:
  * - Ethernet address spans across 3 consective words
-- 
1.7.4.1


