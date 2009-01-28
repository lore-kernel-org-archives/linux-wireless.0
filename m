Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18580 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZA1USc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:18:32 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 12:18:32 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 0/3] ath9k: few reg updates for passive-scan handling
Date: Wed, 28 Jan 2009 12:17:46 -0800
Message-ID: <1233173869-16512-1-git-send-email-lrodriguez@atheros.com> (sfid-20090128_211837_848597_1F7036E4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series lets country IEs supplement world roaming by
removing passive scan flags if one is found. We are looking into
letting users help with this as well but first we need an ACK
from our regulatory team. This should still help.

Luis R. Rodriguez (3):
  ath9k: replace usage of internal wireless_modes for conf
  ath9k: move check for radar freqs into a helper
  ath9k: remove passive scan on 5 GHz if country IE knows better

 drivers/net/wireless/ath9k/regd.c |   31 ++++++++++++++++++++-----------
 1 files changed, 20 insertions(+), 11 deletions(-)

