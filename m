Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27285 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752718AbYBRCUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 21:20:43 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 0/3] IBSS merge final resend
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Mon, 18 Feb 2008 11:20:29 +0900
Message-ID: <20080218021448.5488.10305.stgit@one> (sfid-20080218_022058_340704_0B00FE0E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series implements IBSS merging.

it is based on wireless-2.6 everything. 

bruno

---

Bruno Randolf (3):
      mac80211: enable IBSS merging
      mac80211: move function ieee80211_sta_join_ibss()
      mac80211: better definition of mactime


 include/net/mac80211.h       |    6 -
 net/mac80211/ieee80211_sta.c |  407 +++++++++++++++++++++++-------------------
 net/mac80211/rx.c            |    5 -
 3 files changed, 228 insertions(+), 190 deletions(-)

-- 

