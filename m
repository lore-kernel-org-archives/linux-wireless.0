Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28521 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbZFJM0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 08:26:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 05:26:21 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 0/3] Few clean ups
Date: Wed, 10 Jun 2009 17:50:06 +0530
Message-ID: <1244636409-9946-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are few clean ups which apply over Luis' rc cleanup
series.
 
Vasanthakumar Thiagarajan (3):
  ath9k: Nuke unneccesary helper function to see if aggr is active
  ath9k: Remove unnecessary count for addba attempt
  ath9k: downgrade ASSERT() in ath_clone_txbuf()

 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   33 +++++++------------------------
 2 files changed, 8 insertions(+), 26 deletions(-)

