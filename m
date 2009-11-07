Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37899 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753586AbZKGWA5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 17:00:57 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: John Linville <linville@tuxdriver.com>
Cc: Lennert Buytenhek <buytenh@marvell.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 22:00:57 +0000
Message-ID: <1257631257.15927.466.camel@localhost>
Mime-Version: 1.0
Subject: [PATCH 52/75] mwl8k: declare MODULE_FIRMWARE
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwl8k.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index c0317e2..e85872c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -387,6 +387,9 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv, u32 part_num)
 	return 0;
 }
 
+MODULE_FIRMWARE("mwl8k/helper_8687.fw");
+MODULE_FIRMWARE("mwl8k/fmimage_8687.fw");
+
 struct mwl8k_cmd_pkt {
 	__le16	code;
 	__le16	length;
-- 
1.6.5.2



