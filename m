Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:10960 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753418Ab0CBH62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:58:28 -0500
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0682086707
	for <linux-wireless@vger.kernel.org>; Tue,  2 Mar 2010 16:58:27 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
Subject: [PATCH 0/4] ath5k cleanup
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 02 Mar 2010 16:58:26 +0900
Message-ID: <20100302075526.20555.14622.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi!

this is a series of cleanup patches for ath5k. as the beginning of a larger
initiative to merge ath5k_hw and ath5k_softc i have removed the double use of
'opmode' and removed some unused variables in ath5k_hw. please check if anyone
still needs these definitions...

thanks,
bruno

---

Bruno Randolf (4):
      ath5k: remove ah_gpio_npins
      ath5k: remove ah_mac_revision
      ath5k: remove ah_magic
      ath5k: remove double opmode definition


 drivers/net/wireless/ath/ath5k/ath5k.h  |    7 +------
 drivers/net/wireless/ath/ath5k/attach.c |    4 +---
 drivers/net/wireless/ath/ath5k/base.c   |    7 ++++---
 drivers/net/wireless/ath/ath5k/caps.c   |    3 ---
 drivers/net/wireless/ath/ath5k/desc.c   |    6 ------
 drivers/net/wireless/ath/ath5k/eeprom.h |    3 ---
 drivers/net/wireless/ath/ath5k/pcu.c    |   14 +++++++-------
 drivers/net/wireless/ath/ath5k/reset.c  |    9 ++-------
 8 files changed, 15 insertions(+), 38 deletions(-)

-- 
Signature
