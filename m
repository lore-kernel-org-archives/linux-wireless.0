Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:38175 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbaCIG5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 01:57:07 -0500
Subject: [PATCH 0/6] ath6kl: fixing new checkpatch warnings
To: ath6kl@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 09 Mar 2014 08:57:05 +0200
Message-ID: <20140309065606.10793.67068.stgit@x230> (sfid-20140309_075712_089434_1EDC12BA)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

this patchset fixes new checkpatch warnings which have appeared during the last
year or so.

---

Kalle Valo (6):
      ath6kl: fix blank lines before and after braces
      ath6kl: use braces on both arms of if statement
      ath6kl: remove spaces before semicolon
      ath6kl: remove unnecessary line continuations
      ath6kl: remove a warning on a macro
      ath6kl: update Kconfig descriptions


 drivers/net/wireless/ath/ath6kl/Kconfig    |   30 +++++++++++++++++++++------
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    9 ++++----
 drivers/net/wireless/ath/ath6kl/core.c     |    5 +++--
 drivers/net/wireless/ath/ath6kl/debug.c    |   14 ++++---------
 drivers/net/wireless/ath/ath6kl/debug.h    |    2 +-
 drivers/net/wireless/ath/ath6kl/hif.c      |    3 ---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   23 +++++----------------
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |   10 +--------
 drivers/net/wireless/ath/ath6kl/init.c     |    1 -
 drivers/net/wireless/ath/ath6kl/main.c     |   10 ++++-----
 drivers/net/wireless/ath/ath6kl/sdio.c     |   15 +++++---------
 drivers/net/wireless/ath/ath6kl/target.h   |    2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |   31 ++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/usb.c      |    2 --
 drivers/net/wireless/ath/ath6kl/wmi.c      |   19 +++++++----------
 drivers/net/wireless/ath/ath6kl/wmi.h      |    1 -
 16 files changed, 79 insertions(+), 98 deletions(-)

