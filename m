Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37837 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbcGDLJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 07:09:26 -0400
Received: by mail-wm0-f51.google.com with SMTP id a66so110874284wme.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2016 04:09:25 -0700 (PDT)
From: lemagoup@gmail.com
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	jmassot@aldebaran.com,
	Pierre Le Magourou <plemagourou@aldebaran.com>
Subject: [PATCH v2 0/3] ath6kl: Fix tethering problems
Date: Mon,  4 Jul 2016 13:07:16 +0200
Message-Id: <20160704110719.7694-1-plemagourou@aldebaran.com> (sfid-20160704_130946_748901_4DFA1C9A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pierre Le Magourou <plemagourou@aldebaran.com>

These 3 patchs fix problems detected when using tethering mode with a
AR9374 chipset.

v2:
 * Change "From:" line of the email header
 * Remove locking from "Unset IFF_LOWER_UP flag on AP mode leave" patch


Pierre Le Magourou (3):
  ath6kl: Fix WLAN tethering authentication problem.
  ath6kl: Fix wrong regulatory domain disconnection.
  ath6kl: Unset IFF_LOWER_UP flag on AP mode leave.

 drivers/net/wireless/ath/ath6kl/cfg80211.c | 4 +++-
 drivers/net/wireless/ath/ath6kl/txrx.c     | 9 +++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.9.0

