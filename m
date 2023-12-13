Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NhxDAmPb"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BD1D5;
	Tue, 12 Dec 2023 21:48:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=KU1Cgo4qyY1SwQIo3YgO9y+5w4gzLZP34CSSzWikOKQ=; b=NhxDAmPbtxp0twl0bWLa0KfhYe
	Uo5KxCR7tm9Cnr+DRq5dKmZpioeI1K/ooRTCFIu3t7tEUGdTqHcrzHvwxiC965ucbdmHYN1fa4x/3
	fe0BEGZM2xUPIygIC0qNjO+39iJvKc9AMD3vfWsZi/4YwsyxmyuFEXYlX/rGQIakaiV9o1EfMz5jx
	kStntqhvD6SGll1ShXZr/a3pk9iNfIASMCtQ+iXmqkDXn0S6EV/UmyvjGlMcSNV7GiFFY+kuMJjKs
	S0hPzuQgrErieuydFxJes7GDK3MfPsbe/4TBqxyXis7AckNxYkTMp0QHNpVm8nw8tEg9447xXvN/k
	TYr9s8Tw==;
Received: from [50.53.46.231] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDI6C-00DgAG-2z;
	Wed, 13 Dec 2023 05:48:01 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: netdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] wifi: mac80211: rx.c: fix sentence grammar
Date: Tue, 12 Dec 2023 21:48:00 -0800
Message-ID: <20231213054800.22561-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Correct a run-on sentence by changing "," to ";".
Add a subject in one sentence.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 net/mac80211/rx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -- a/net/mac80211/rx.c b/net/mac80211/rx.c
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -920,7 +920,7 @@ static void ieee80211_parse_qos(struct i
  * Drivers always need to pass packets that are aligned to two-byte boundaries
  * to the stack.
  *
- * Additionally, should, if possible, align the payload data in a way that
+ * Additionally, they should, if possible, align the payload data in a way that
  * guarantees that the contained IP header is aligned to a four-byte
  * boundary. In the case of regular frames, this simply means aligning the
  * payload to a four-byte boundary (because either the IP header is directly
@@ -936,7 +936,7 @@ static void ieee80211_parse_qos(struct i
  * subframe to a length that is a multiple of four.
  *
  * Padding like Atheros hardware adds which is between the 802.11 header and
- * the payload is not supported, the driver is required to move the 802.11
+ * the payload is not supported; the driver is required to move the 802.11
  * header to be directly in front of the payload in that case.
  */
 static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
