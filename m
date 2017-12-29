Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52786 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755263AbdL2Ibk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:40 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/11] MAINTAINERS: Change maintainer for rtlwifi
Date: Fri, 29 Dec 2017 16:31:02 +0800
Message-ID: <20171229083112.31540-2-pkshih@realtek.com> (sfid-20171229_093322_102271_B0027C18)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

This section is also modified to include the entire rtlwifi family,
not just RTL8192CE.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 MAINTAINERS | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 129c591e0f34..5f6415573fd3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11775,15 +11775,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
 S:	Maintained
 F:	drivers/net/wireless/realtek/rtl818x/rtl8187/
 
-RTL8192CE WIRELESS DRIVER
-M:	Larry Finger <Larry.Finger@lwfinger.net>
-M:	Chaoming Li <chaoming_li@realsil.com.cn>
+REALTEK WIRELESS DRIVER (rtlwifi family)
+M:	Ping-Ke Shih <pkshih@realtek.com>
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
 S:	Maintained
 F:	drivers/net/wireless/realtek/rtlwifi/
-F:	drivers/net/wireless/realtek/rtlwifi/rtl8192ce/
 
 RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
 M:	Jes Sorensen <Jes.Sorensen@gmail.com>
-- 
2.14.1
