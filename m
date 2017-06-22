Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:41335 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753004AbdFVKBJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 06:01:09 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Subject: [PATCH 4/4] MAINTAINERS: add brcm80211 maintainer info from Cypress
Date: Thu, 22 Jun 2017 11:01:04 +0100
Message-Id: <1498125664-25980-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170622_120125_038985_4A412BE3)
In-Reply-To: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1498125664-25980-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since Cypress took over IoT part of Broadcom some chips supported
by brcmfmac moved over as well. Adding maintainer info of our peers
at Cypress to make their support official.

Cc: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>
Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f4e682c..fa9744f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2785,8 +2785,11 @@ BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
 M:	Arend van Spriel <arend.vanspriel@broadcom.com>
 M:	Franky Lin <franky.lin@broadcom.com>
 M:	Hante Meuleman <hante.meuleman@broadcom.com>
+M:	Chi-Hsien Lin <chi-hsien.lin@cypress.com>
+M:	Wright Feng <wright.feng@cypress.com>
 L:	linux-wireless@vger.kernel.org
 L:	brcm80211-dev-list.pdl@broadcom.com
+L:	brcm80211-dev-list@cypress.com
 S:	Supported
 F:	drivers/net/wireless/broadcom/brcm80211/
 
-- 
1.9.1
