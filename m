Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:12276 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754894AbdJJIJ3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 04:09:29 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V5 0/5] Add TDLS feature for ath10k
Date: Tue, 10 Oct 2017 16:11:15 +0800
Message-ID: <1507623080-9311-1-git-send-email-yintang@qti.qualcomm.com> (sfid-20171010_100933_322017_16F7AF97)
In-Reply-To: <TDLS for ath10k patch>
References: <TDLS for ath10k patch>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yingying Tang <yintang@qti.qualcomm.com>

This patchset is for Rome PCIE chip, it will not affect other hardware

Yingying Tang (5):
  mac80211: Enable TDLS peer buffer STA feature
  ath10k: Enable TDLS peer buffer STA feature
  ath10k: Enable TDLS peer inactivity detection
  ath10k: Avoid to set WEP key for TDLS peer
  ath10k: Fix TDLS peer TX data failure issue on encryped AP

 drivers/net/wireless/ath/ath10k/mac.c     |    9 ++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   55 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   23 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |    1 +
 include/net/cfg80211.h                    |    3 ++
 net/mac80211/tdls.c                       |    5 ++-
 6 files changed, 94 insertions(+), 2 deletions(-)

-- 
1.7.9.5
