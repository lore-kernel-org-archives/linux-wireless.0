Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:38503 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab2JXT7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 15:59:50 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so403982dak.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 12:59:50 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: linville@tuxdriver.com
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net
Subject: [PATCH v2 0/2] Mesh support for ath9k_htc
Date: Wed, 24 Oct 2012 12:59:32 -0700
Message-Id: <1351108774-7450-1-git-send-email-javier@cozybit.com> (sfid-20121024_215953_932975_504DC06D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch was submitted as RFC and triggered no objections.  It's been used by
the o11s.org community for a while.  See
http://marc.info/?l=linux-wireless&m=132252734212491 for context.

Javier Cardona (2):
  ath9k_htc: Add support for NL80211_IFTYPE_MESH_POINT interfaces
  ath9k_htc: Honor FIF_OTHER_BSS

 drivers/net/wireless/ath/ath9k/htc.h            |    7 +++++++
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   17 ++++++++++++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    6 +++++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |    2 +-
 5 files changed, 43 insertions(+), 3 deletions(-)

-- 
v2: Move the FIF_OTHER_BSS hunk to a separate patch (Pavel Roskin)

1.7.5.4

