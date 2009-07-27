Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60481 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbZG0XwM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 19:52:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 16:52:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] atheros: few kconfig cleanups
Date: Mon, 27 Jul 2009 16:52:05 -0700
Message-ID: <1248738730-4003-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just few kconfig cleanups.

Luis R. Rodriguez (5):
  ath: depend on cfg80211
  ath: simplify kconfig dependency and add documentation
  ath: use menuconfig to put ath stuff in its own page
  ath5k: remove EXPERIMENTAL marker
  ar9170: remove EXPERIMENTAL marker

 drivers/net/wireless/ath/Kconfig        |   21 ++++++++++++++++++---
 drivers/net/wireless/ath/ar9170/Kconfig |    4 ++--
 drivers/net/wireless/ath/ath5k/Kconfig  |    3 +--
 drivers/net/wireless/ath/ath9k/Kconfig  |    1 -
 4 files changed, 21 insertions(+), 8 deletions(-)

