Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:31011 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbXJaBpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 21:45:14 -0400
Received: by rv-out-0910.google.com with SMTP id k20so2040534rvb
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 18:45:13 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 29 Oct 2007 19:59:14 -0700
Subject: [PATCH 7/7] o80211s: (nl80211) add basic comments to allow pynl80211 add new virtual interfaces
Message-ID: <4727de29.0eb48c0a.7fdc.ffffbe7f@mx.google.com> (sfid-20071031_014516_892388_63B11DA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/nl80211.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 0e6abae..e90e0ea 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -52,6 +52,7 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_INTERFACE,	/* can dump */
 	NL80211_CMD_SET_INTERFACE,
+	/* %input: wiphy, ifname, {iftype} */
 	NL80211_CMD_NEW_INTERFACE,
 	NL80211_CMD_DEL_INTERFACE,
 
@@ -87,12 +88,15 @@ enum nl80211_commands {
 enum nl80211_attrs {
 /* don't change the order or add anything inbetween, this is ABI! */
 	NL80211_ATTR_UNSPEC,
-
+	/* %type: u32 */
 	NL80211_ATTR_WIPHY,
 	NL80211_ATTR_WIPHY_NAME,
 
+	/* %type: u32 */
 	NL80211_ATTR_IFINDEX,
+	/* %type: nulstring */
 	NL80211_ATTR_IFNAME,
+	/* %type: u32 */
 	NL80211_ATTR_IFTYPE,
 
 	/* add attributes here, update the policy in nl80211.c */
-- 
1.5.2.5



