Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33598 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLRXSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 18:18:17 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so2965308wgh.20
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 15:18:16 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 0/3] add debugfs support to ath9k hw TPC
Date: Fri, 19 Dec 2014 00:18:11 +0100
Message-Id: <1418944694-10614-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141219_001821_223211_1D8CBA1F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*[PATCH 1/3]: enable TPC by default on AR9003 based chips
*[PATCH 2/3]: enable/disable hw TPC through debugfs
*[PATCH 3/3]: fix typo

Lorenzo Bianconi (3):
  ath9k: enable TPC by default
  ath9k: add debugfs support for hw TPC
  ath9k: fix typo

 drivers/net/wireless/ath/ath9k/debug.c | 71 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c    |  3 ++
 drivers/net/wireless/ath/ath9k/xmit.c  |  2 +-
 3 files changed, 75 insertions(+), 1 deletion(-)

-- 
2.1.0

