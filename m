Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39873 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYIJNXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 09:23:53 -0400
Date: Wed, 10 Sep 2008 18:48:25 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: RF kill support for ath9k
Message-ID: <20080910131825.GA7733@vasanth-lnx.users.atheros.com> (sfid-20080910_152356_036867_6891423F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

This patch series mainly contains RF kill support.

Regards,

Vasanth

Vasanthakumar Thiagarajan (2):
  ath9k: Re-order functions in main.c
  ath9k: Add RF kill support

 drivers/net/wireless/ath9k/ath9k.h |    7 +-
 drivers/net/wireless/ath9k/core.h  |   16 +
 drivers/net/wireless/ath9k/hw.c    |   70 ++-
 drivers/net/wireless/ath9k/main.c  | 1204 ++++++++++++++++++++++--------------
 4 files changed, 796 insertions(+), 501 deletions(-)

