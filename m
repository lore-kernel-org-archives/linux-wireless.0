Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39315 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755919AbYIIPi4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 11:38:56 -0400
Date: Tue, 9 Sep 2008 21:03:29 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: RF kill support for ath9k
Message-ID: <20080909153328.GA7617@vasanth-lnx.users.atheros.com> (sfid-20080909_173921_731465_13730E28)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please find the latest RF kill patch for ath9k which 
addresses the review comments over my previous patch.

Regards

Vasanth

Vasanthakumar Thiagarajan (1):
  ath9k: Add RF kill support

 drivers/net/wireless/ath9k/Kconfig |    1 +
 drivers/net/wireless/ath9k/ath9k.h |    9 +-
 drivers/net/wireless/ath9k/core.h  |   24 +
 drivers/net/wireless/ath9k/hw.c    |   70 ++-
 drivers/net/wireless/ath9k/hw.h    |    2 -
 drivers/net/wireless/ath9k/main.c  | 1205 ++++++++++++++++++++++--------------
 6 files changed, 808 insertions(+), 503 deletions(-)

