Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbYJ2LtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 07:49:15 -0400
Subject: [PATCH] iwl3945: remove bogus comment
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 01:02:27 +0100
Message-Id: <1225238548.1369.10.camel@johannes.berg> (sfid-20081029_124930_172035_D3C9AE0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I added this comment myself, but it's clearly wrong. I had meant
to place it in iwl_mac_add_interface, which at the time didn't
honour the MAC address setting, but it does now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 --
 1 file changed, 2 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-29 00:58:17.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-10-29 00:58:26.000000000 +0100
@@ -6742,8 +6742,6 @@ static int iwl3945_mac_config_interface(
 			return rc;
 	}
 
-	/* XXX: this MUST use conf->mac_addr */
-
 	if (!iwl3945_is_alive(priv))
 		return -EAGAIN;
 


