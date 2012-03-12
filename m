Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:36706 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab2CLLWv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 07:22:51 -0400
Subject: [PATCH 0/4] ath6kl: more checkpatch fixes
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 12 Mar 2012 13:22:39 +0200
Message-ID: <20120312112131.23253.74137.stgit@x201> (sfid-20120312_122258_242649_6663D196)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Few more checkpatch fixes and one fix for a regression from my previous
checkpatch fixes.

---

Kalle Valo (4):
      ath6kl: fix regression in ath6kl_upload_board_file()
      ath6kl: replace strict_strtoul() with kstrtoul()
      ath6kl: fix open parenthesis alignment in ath6kl_sdio_suspend()
      ath6kl: use max_t() in ath6kl_cfg80211_connect()


 drivers/net/wireless/ath/ath6kl/cfg80211.c |    4 ++--
 drivers/net/wireless/ath/ath6kl/debug.c    |   19 ++-----------------
 drivers/net/wireless/ath/ath6kl/init.c     |    3 ++-
 drivers/net/wireless/ath/ath6kl/sdio.c     |    9 +++++----
 4 files changed, 11 insertions(+), 24 deletions(-)

