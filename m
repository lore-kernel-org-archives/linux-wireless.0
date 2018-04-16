Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57016 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754207AbeDPNQn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:16:43 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 0/5] wcn36xx: scan related patches
Date: Mon, 16 Apr 2018 15:16:29 +0200
Message-Id: <20180416131634.25432-1-daniel@zonque.org> (sfid-20180416_151647_437096_C9438A78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's another series of 5 patches for wcn36xx that address some issues
with scanning. The first one is the most important one.


Daniel

Daniel Mack (5):
  wcn36xx: abort scan request when 'dequeued' indicator is sent
  wcn36xx: cancel pending scan request when interface goes down
  wcn36xx: handle scan cancellation when firmware support is missing
  wcn36xx: send bss_type in scan requests
  wcn36xx: pass information elements in scan requests

 drivers/net/wireless/ath/wcn36xx/hal.h     |  8 +++++++-
 drivers/net/wireless/ath/wcn36xx/main.c    | 29 +++++++++++++++++++++++++----
 drivers/net/wireless/ath/wcn36xx/smd.c     | 20 +++++++++++++++++---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  7 +------
 4 files changed, 50 insertions(+), 14 deletions(-)

-- 
2.14.3
