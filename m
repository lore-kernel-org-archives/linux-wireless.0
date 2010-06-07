Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:24333 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750803Ab0FGELE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 00:11:04 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0272243862
	for <linux-wireless@vger.kernel.org>; Mon,  7 Jun 2010 13:11:03 +0900 (JST)
Subject: [PATCH 0/5] Series short description
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 07 Jun 2010 13:11:14 +0900
Message-ID: <20100607041012.18667.6859.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

here i resend the missing ath5k patches rebased against current
wireless-testing.

bruno

---

Bruno Randolf (5):
      ath5k: fix NULL pointer in antenna configuration
      ath5k: update AR5K_PHY_RESTART_DIV_GC values to match masks
      ath5k: new function for setting the antenna switch table
      ath5k: no need to save/restore the default antenna
      ath5k: add debugfs file for queue debugging


 drivers/net/wireless/ath/ath5k/ath5k.h |    1 
 drivers/net/wireless/ath/ath5k/debug.c |   73 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/debug.h |    1 
 drivers/net/wireless/ath/ath5k/phy.c   |   43 ++++++++++++++++++-
 drivers/net/wireless/ath/ath5k/reset.c |   41 +++---------------
 5 files changed, 123 insertions(+), 36 deletions(-)

-- 
Signature
