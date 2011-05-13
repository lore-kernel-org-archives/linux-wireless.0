Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4914 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758811Ab1EMKAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:15 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 32/32] staging: brcm80211: fix checkpatch issue in
 wlc_channel.c
Date: Fri, 13 May 2011 11:59:52 +0200
Message-ID: <1305280792-9475-32-git-send-email-arend@broadcom.com> (sfid-20110513_120031_555861_BD696B57)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "[ba84f65] make function definitions and prototype consistent"
introduced a checkpatch warning which is fixed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index e31e392..a3a2bf9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -107,7 +107,8 @@ static void wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *
 								 *txpwr,
 								 u8
 								 local_constraint_qdbm);
-static void wlc_locale_add_channels(chanvec_t *target, const chanvec_t *channels);
+static void wlc_locale_add_channels(chanvec_t *target,
+				    const chanvec_t *channels);
 static const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx);
 static const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx);
 
@@ -397,7 +398,8 @@ static const chanvec_t *g_table_locale_base[] = {
 	&locale_5g_HIGH4
 };
 
-static void wlc_locale_add_channels(chanvec_t *target, const chanvec_t *channels)
+static void wlc_locale_add_channels(chanvec_t *target,
+				    const chanvec_t *channels)
 {
 	u8 i;
 	for (i = 0; i < sizeof(chanvec_t); i++) {
-- 
1.7.4.1


