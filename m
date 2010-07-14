Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121Ab0GNB10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 21:27:26 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] ath9k: flush patches
Date: Tue, 13 Jul 2010 21:27:22 -0400
Message-Id: <1279070845-29442-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patchs add the mac8021 flush op to both ath9k and ath9k_htc.
Tested with AR9003 and AR9271.

Luis R. Rodriguez (3):
  ath9k: implement mac80211 flush op
  ath9k_htc: implement mac80211 flush op
  ath9k_htc: make ath9k_htc_tx_aggr_oper() static

 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   33 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath9k/main.c         |   19 ++++++++++++++
 2 files changed, 48 insertions(+), 4 deletions(-)

