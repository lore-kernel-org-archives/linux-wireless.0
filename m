Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0136.outbound.protection.outlook.com ([104.47.38.136]:43569
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937096AbeE3Gym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 02:54:42 -0400
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
To: linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Josh Boyer <jwboyer@kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Subject: [PATCH V4 1/6] Update Cypress license termination clause
Date: Wed, 30 May 2018 01:54:22 -0500
Message-Id: <1527663267-71412-2-git-send-email-chi-hsien.lin@cypress.com> (sfid-20180530_085519_645484_C5827F9D)
In-Reply-To: <1527663267-71412-1-git-send-email-chi-hsien.lin@cypress.com>
References: <1527663267-71412-1-git-send-email-chi-hsien.lin@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the early-termination clause.

Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
---
 LICENCE.cypress | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/LICENCE.cypress b/LICENCE.cypress
index b320f27..070ef66 100644
--- a/LICENCE.cypress
+++ b/LICENCE.cypress
@@ -56,9 +56,8 @@ human-readable form; or (iv) use the Software other than for the Purpose.
 No Support.  Cypress may, but is not required to, provide technical support for
 the Software.
 
-Term and Termination.  This Agreement is effective until terminated, and either
-party may terminate this Agreement at any time with or without cause.  Your
-license rights under this Agreement will terminate immediately without notice
+Term and Termination.  This Agreement is effective until terminated.  This
+Agreement and Your license rights will terminate immediately without notice
 from Cypress if you fail to comply with any provision of this Agreement.  Upon
 termination, you must destroy all copies of Software in your possession or
 control.  Termination of this Agreement will not affect any licenses validly
-- 
2.1.0
