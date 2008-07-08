Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbYGHQPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 12:15:22 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Remove an extraneous label from the Intel Wifi driver
To: yi.zhu@intel.com, reinette.chatre@intel.com,
	akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-wireless@vger.kernel.org
Date: Tue, 08 Jul 2008 17:15:14 +0100
Message-ID: <20080708161514.9982.32985.stgit@warthog.procyon.org.uk> (sfid-20080708_181525_459513_068669C1)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove an extraneous label from the Intel Wifi driver for which the goto has
been removed.

The label was added in patch ad97edd2f524940d524c26ae273a4eb23067a7c0.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/net/wireless/iwlwifi/iwl-rfkill.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
index aa9f31e..cde1141 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
@@ -111,7 +111,6 @@ unregister_rfkill:
 	rfkill_unregister(priv->rfkill_mngr.rfkill);
 	priv->rfkill_mngr.rfkill = NULL;
 
-freed_rfkill:
 	if (priv->rfkill_mngr.rfkill != NULL)
 		rfkill_free(priv->rfkill_mngr.rfkill);
 	priv->rfkill_mngr.rfkill = NULL;

