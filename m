Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1913 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1F2Xsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:33 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 037/119] staging: brcm80211: remove unused globals from
 dhd_common.c
Date: Wed, 29 Jun 2011 16:47:01 -0700
Message-ID: <1309391303-22741-38-git-send-email-frankyl@broadcom.com> (sfid-20110630_014845_615550_DB373E07)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Three global variable were defined but never used and have been
removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index bb9a72a..cb7e455 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -35,11 +35,6 @@ int dhd_msg_level;
 char fw_path[MOD_PARAM_PATHLEN];
 char nv_path[MOD_PARAM_PATHLEN];
 
-/* Last connection success/failure status */
-u32 dhd_conn_event;
-u32 dhd_conn_status;
-u32 dhd_conn_reason;
-
 extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 			    uint len);
 extern void dhd_ind_scan_confirm(void *h, bool status);
-- 
1.7.1


