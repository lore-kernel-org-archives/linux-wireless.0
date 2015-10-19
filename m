Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f196.google.com ([209.85.212.196]:35453 "EHLO
	mail-wi0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbbJSQCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 12:02:33 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: kvalo@codeaurora.org, zajec5@gmail.com, davem@davemloft.net,
	joe@perches.com, johannes.berg@intel.com, sd@queasysnail.net,
	m@bues.ch, mike.looijmans@topic.nl, khoroshilov@ispras.ru,
	cengelma@gmx.at, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Coding Style Cleanning
Date: Mon, 19 Oct 2015 17:02:20 +0100
Message-Id: <1445270543-2209-1-git-send-email-paulmcquad@gmail.com> (sfid-20151019_180358_198552_A9D2BE65)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul McQuade (3):
  net: wireless: rsi: Coding Spaces
  net: wireless: b43: Coding Style
  net: wireless: b43: Statics are init to 0

 drivers/net/wireless/b43/main.c             | 8 ++++----
 drivers/net/wireless/b43/main.h             | 2 +-
 drivers/net/wireless/b43/phy_lp.c           | 2 +-
 drivers/net/wireless/b43/xmit.h             | 2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 2 +-
 drivers/net/wireless/rsi/rsi_mgmt.h         | 4 ++--
 6 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.6.1

