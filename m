Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward1o.cmail.yandex.net ([37.9.109.84]:33654 "EHLO
        forward1o.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbcLERxu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 12:53:50 -0500
From: Ozgur Karatas <okaratas@member.fsf.org>
To: johannes@sipsolutions.net, David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 130/130] Fixed to checkpatch errors.
MIME-Version: 1.0
Message-Id: <459781480959747@web17h.yandex.ru> (sfid-20161205_185352_649286_F7698202)
Date: Mon, 05 Dec 2016 19:42:27 +0200
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Fixed to checkpatch errors.

ERROR: net/wireless/util.c:1787: ERROR: that open brace { should be on the previous line
ERROR: net/wireless/util.c:1792: ERROR: that open brace { should be on the previous line

Signed-off-by: Ozgur Karatas <okaratas@member.fsf.org>
---
 net/wireless/util.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 659b507..f4ac755 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1783,11 +1783,13 @@ EXPORT_SYMBOL(cfg80211_free_nan_func);
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
-const unsigned char rfc1042_header[] __aligned(2) =
-	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+const unsigned char rfc1042_header[] __aligned(2) = {
+	0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00
+};
 EXPORT_SYMBOL(rfc1042_header);
 
 /* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
-const unsigned char bridge_tunnel_header[] __aligned(2) =
-	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
+const unsigned char bridge_tunnel_header[] __aligned(2) = {
+	0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8
+};
 EXPORT_SYMBOL(bridge_tunnel_header);
-- 
2.1.4
