Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51524 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730203AbeHNB6H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 21:58:07 -0400
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [RFC 0/3] mac80211: handle push-pull path in ATF
Date: Mon, 13 Aug 2018 16:13:28 -0700
Message-Id: <1534202011-13101-1-git-send-email-rmanohar@codeaurora.org> (sfid-20180814_011347_559967_6EE0A410)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke,

Here are my pending changes on top of your 1st version of ATF.
I am posting these RFCs for more feedback. I havn't posted ath10k changes
and planned to do it later. Kindly review.

-Rajkumar

Rajkumar Manoharan (3):
  mac80211: make airtime txq list per ac
  mac80211: pause txq transmission on negative airtime deficit
  mac80211: add ieee80211_reorder_txq

 include/net/mac80211.h     | 15 ++++++++
 net/mac80211/debugfs_sta.c |  7 ++--
 net/mac80211/ieee80211_i.h |  3 +-
 net/mac80211/main.c        |  3 +-
 net/mac80211/sta_info.c    |  9 +++++
 net/mac80211/tx.c          | 87 +++++++++++++++++++++++++++++++++++-----------
 6 files changed, 98 insertions(+), 26 deletions(-)

-- 
1.9.1
