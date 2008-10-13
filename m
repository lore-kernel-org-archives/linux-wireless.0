Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:31246 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbYJMQQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 12:16:27 -0400
Date: Mon, 13 Oct 2008 09:15:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fixme for kernel-doc
Message-Id: <20081013091501.33146a4d.randy.dunlap@oracle.com> (sfid-20081013_181632_497926_7D3833EB)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in mac80211.h.
Fields need real explanations added to them.

Warning(lin2627-g3-kdocfixes//include/net/mac80211.h:659): No description found for parameter 'icv_len'
Warning(lin2627-g3-kdocfixes//include/net/mac80211.h:659): No description found for parameter 'iv_len'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/net/mac80211.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- lin2627-g3-kdocfixes.orig/include/net/mac80211.h
+++ lin2627-g3-kdocfixes/include/net/mac80211.h
@@ -645,7 +645,8 @@ enum ieee80211_key_flags {
  * 	- Temporal Encryption Key (128 bits)
  * 	- Temporal Authenticator Tx MIC Key (64 bits)
  * 	- Temporal Authenticator Rx MIC Key (64 bits)
- *
+ * @icv_len: FIXME
+ * @iv_len: FIXME
  */
 struct ieee80211_key_conf {
 	enum ieee80211_key_alg alg;
