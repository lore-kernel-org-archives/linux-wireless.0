Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26109 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078Ab0JTN7s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 09:59:48 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 06:59:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/3] wireless: a few sparse fixes
Date: Wed, 20 Oct 2010 06:59:35 -0700
Message-ID: <1287583178-2963-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a few sparse fixes which were poking my eyes out.

Luis R. Rodriguez (3):
  ath: make ath_hw_keysetmac() static
  ath: make ath_hw_set_keycache_entry() static
  ath5k: make ath5k_update_bssid_mask_and_opmode() static

 drivers/net/wireless/ath/ath5k/base.c |    4 ++--
 drivers/net/wireless/ath/key.c        |    9 +++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

