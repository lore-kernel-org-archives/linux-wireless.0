Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2944 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbYF0PRY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 11:17:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath5k: remove now unused variable declared in ath5k_tx
Date: Fri, 27 Jun 2008 11:10:50 -0400
Message-Id: <1214579450-14470-1-git-send-email-linville@tuxdriver.com> (sfid-20080627_171726_990354_F1D55A62)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/ath5k/base.o
drivers/net/wireless/ath5k/base.c: In function =E2=80=98ath5k_tx=E2=80=99=
:
drivers/net/wireless/ath5k/base.c:2598: warning: unused variable =E2=80=
=98info=E2=80=99

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath5k/base.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/a=
th5k/base.c
index a80a3a4..a43e9b2 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2595,7 +2595,6 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff =
*skb)
 {
 	struct ath5k_softc *sc =3D hw->priv;
 	struct ath5k_buf *bf;
-	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	unsigned long flags;
 	int hdrlen;
 	int pad;
--=20
1.5.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
