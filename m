Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39786 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbYIQEql (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 00:46:41 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18640.35637.877669.967377@gargle.gargle.HOWL> (sfid-20080917_064646_018037_C0409299)
Date: Wed, 17 Sep 2008 10:14:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 0/3] Beacon handling fixes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

A couple of fixes for beacon handling in IBSS mode.

Sujith

Sujith (3):
  ath9k: Whitespace cleanup
  ath9k: Fix nexttbtt calculation
  ath9k: Fix TSF Adjust usage

 drivers/net/wireless/ath9k/beacon.c |  145 ++++++++++++++++-------------------
 drivers/net/wireless/ath9k/core.c   |    3 +-
 drivers/net/wireless/ath9k/core.h   |    1 +
 3 files changed, 69 insertions(+), 80 deletions(-)

