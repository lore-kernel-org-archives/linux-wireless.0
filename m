Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:14986 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754544AbYBEKtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 05:49:23 -0500
From: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH 0/2] ibss merge resend
To: ath5k-devel@lists.ath5k.org
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, flamingice@sourmilk.net, jbenc@suse.cz
Date: Tue, 05 Feb 2008 19:49:06 +0900
Message-ID: <20080205104543.9379.47253.stgit@one> (sfid-20080205_104929_385087_EF823AA4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello!

i resend my ibss merge patch, in order to address all issues that have come up
since the first try. the first patch just moves the function
ieee80211_sta_join_ibss(), the second one changes functionality.

greetings, 

bruno

---

Bruno Randolf (2):
      mac80211: enable IBSS merging
      mac80211: move function ieee80211_sta_join_ibss()


 net/mac80211/ieee80211_sta.c |  385 ++++++++++++++++++++++--------------------
 net/mac80211/rx.c            |    5 -
 2 files changed, 204 insertions(+), 186 deletions(-)

