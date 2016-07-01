Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35637 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbcGAQKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 12:10:39 -0400
Received: by mail-wm0-f47.google.com with SMTP id v199so32467669wmv.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2016 09:10:38 -0700 (PDT)
From: Pierre Le Magourou <lemagoup@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	jmassot@aldebaran.com,
	Pierre Le Magourou <plemagourou@aldebaran.com>
Subject: [PATCH 0/3] ath6kl: Fix tethering problems
Date: Fri,  1 Jul 2016 18:10:02 +0200
Message-Id: <20160701161005.30341-1-plemagourou@aldebaran.com> (sfid-20160701_181043_066379_A9EF6239)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These 3 patchs fix problems detected when using tethering mode with a
AR9374 chipset.

Pierre Le Magourou (3):
  ath6kl: Fix WLAN tethering authentication problem.
  ath6kl: Fix wrong regulatory domain disconnection.
  ath6kl: Unset IFF_LOWER_UP flag on AP mode leave.

 drivers/net/wireless/ath/ath6kl/cfg80211.c | 7 ++++++-
 drivers/net/wireless/ath/ath6kl/txrx.c     | 9 +++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

-- 
2.9.0

