Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 16/16] rtl8xxxu: MAINTAINERS: Update to point to the active devel branch
Date: Thu, 14 Apr 2016 16:37:21 -0400
Message-Id: <1460666241-5365-17-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_223737_856731_38D7079D)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Update the MAINTAINERS info to reflect active development of the
rtl8xxxu driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4851f02..6ac970b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9490,7 +9490,7 @@ F:	drivers/net/wireless/realtek/rtlwifi/rtl8192ce/
 RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
 M:	Jes Sorensen <Jes.Sorensen@redhat.com>
 L:	linux-wireless@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git rtl8723au-mac80211
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git rtl8xxxu-devel
 S:	Maintained
 F:	drivers/net/wireless/realtek/rtl8xxxu/
 
-- 
2.5.5

