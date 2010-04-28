Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:46529 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab0D1Gua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 02:50:30 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] wl1271: patches of the week
Date: Wed, 28 Apr 2010 09:49:58 +0300
Message-Id: <1272437402-28801-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

It has been a while since I last sent patches for wl1271, but there hasn't been too much going on with the wl1271 driver itself.  Most of our work is going to mac80211 at the moment.

Anyway, it's time to send them so that we catch up.

Cheers,
Luca.

Juuso Oikarinen (2):
  wl1271: Improve command polling
  wl1271: Rewrite hardware keep-alive handling

Luciano Coelho (1):
  wl1271: fix a bunch of sparse warnings

Saravanan Dhanabal (1):
  wl1271: Configure QOS nullfunc template for U-APSD

 drivers/net/wireless/wl12xx/wl1271_acx.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c |    8 +-
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   14 ++--
 drivers/net/wireless/wl12xx/wl1271_conf.h |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   95 +++++++++++++++--------------
 5 files changed, 63 insertions(+), 58 deletions(-)

