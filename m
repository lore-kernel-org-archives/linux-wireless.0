Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40323 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966899AbaLLLyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 06:54:31 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so8934652wgh.31
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2014 03:54:30 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/5] ath10k: a bunch of STA-related fixes
Date: Fri, 12 Dec 2014 12:41:34 +0100
Message-Id: <1418384499-31660-1-git-send-email-michal.kazior@tieto.com> (sfid-20141212_125435_384072_5AE4D3BE)
In-Reply-To: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
References: <1418214714-29689-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Michal Kazior (5):
  ath10k: improve 11b coex
  ath10k: fix STA u-APSD
  ath10k: prevent invalid ps timeout config
  ath10k: enable per-vif sta powersave
  ath10k: advertise p2p dev support

 drivers/net/wireless/ath/ath10k/core.c |   6 --
 drivers/net/wireless/ath/ath10k/mac.c  | 127 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.h  |   7 ++
 3 files changed, 115 insertions(+), 25 deletions(-)

-- 
1.8.5.3

