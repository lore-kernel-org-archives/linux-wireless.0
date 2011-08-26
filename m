Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4781 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/13] staging: brcm80211: remove unused definition flag
 from top Makefile
Date: Fri, 26 Aug 2011 15:19:28 +0200
Message-ID: <1314364780-9462-2-git-send-email-rvossen@broadcom.com> (sfid-20110826_152017_046942_B38C64F4)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The use of the definition BCMDMA32 was already removed from the
source code, but it was still defined in the top-level Makefile.
This patch removes it.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
index 8b01f5e..f41c047 100644
--- a/drivers/staging/brcm80211/Makefile
+++ b/drivers/staging/brcm80211/Makefile
@@ -16,7 +16,6 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 # common flags
-subdir-ccflags-y					:= -DBCMDMA32
 subdir-ccflags-$(CONFIG_BRCMDBG)	+= -DBCMDBG
 
 obj-$(CONFIG_BRCMUTIL)	+= brcmutil/
-- 
1.7.4.1


