Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:58157 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbcFCVbX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:31:23 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/6] brcm80211: update maintainers email addresses
Date: Fri,  3 Jun 2016 23:31:12 +0200
Message-Id: <1464989472-29684-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20160603_233127_983878_B6E123B8)
In-Reply-To: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1464989472-29684-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Update MAINTAINERS file because of organizational changes.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 MAINTAINERS | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ee2fad5..e06f556 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2485,12 +2485,11 @@ S:	Supported
 F:	drivers/net/ethernet/broadcom/tg3.*
 
 BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
-M:	Brett Rudley <brudley@broadcom.com>
-M:	Arend van Spriel <arend@broadcom.com>
-M:	Franky (Zhenhui) Lin <frankyl@broadcom.com>
-M:	Hante Meuleman <meuleman@broadcom.com>
+M:	Arend van Spriel <arend.vanspriel@broadcom.com>
+M:	Franky Lin <franky.lin@broadcom.com>
+M:	Hante Meuleman <hante.meuleman@broadcom.com>
 L:	linux-wireless@vger.kernel.org
-L:	brcm80211-dev-list@broadcom.com
+L:	brcm80211-dev-list.pdl@broadcom.com
 S:	Supported
 F:	drivers/net/wireless/broadcom/brcm80211/
 
-- 
1.9.1

