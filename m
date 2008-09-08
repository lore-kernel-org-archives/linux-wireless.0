Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39543 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbYIHGwF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 02:52:05 -0400
Date: Mon, 8 Sep 2008 12:16:41 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 0/1] rfkill support for ath9k driver
Message-ID: <20080908064641.GA30360@vasanth-lnx.users.atheros.com> (sfid-20080908_085210_031396_3DB8E960)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I have addressed Marcel's review comments in this patch.

Regards
Vasanth

Vasanthakumar Thiagarajan (1):
  ath9k: Add RF kill support

 drivers/net/wireless/ath9k/Kconfig |    1 +
 drivers/net/wireless/ath9k/ath9k.h |    4 +
 drivers/net/wireless/ath9k/core.h  |   16 +
 drivers/net/wireless/ath9k/hw.c    |   64 +-
 drivers/net/wireless/ath9k/hw.h    |    2 -
 drivers/net/wireless/ath9k/main.c  | 1186 ++++++++++++++++++++++--------------
 6 files changed, 772 insertions(+), 501 deletions(-)

