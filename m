Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:32628 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751230AbdIOLCd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 07:02:33 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [TDLS PATCH V1 0/5] Add TDLS feature for ath10k
Date: Fri, 15 Sep 2017 19:03:35 +0800
Message-ID: <1505473420-22932-1-git-send-email-yintang@qti.qualcomm.com> (sfid-20170915_130237_036399_49354856)
In-Reply-To: <TDLS for ath10k>
References: <TDLS for ath10k>
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
  ath10k: Avoid to set WEP key for TDLS peer

 drivers/net/wireless/ath/ath10k/mac.c     |    9 ++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |   55 +++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |   23 ++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |    1 +
 include/net/cfg80211.h                    |    3 ++
 net/mac80211/tdls.c                       |    5 ++-
 6 files changed, 94 insertions(+), 2 deletions(-)

-- 
1.7.9.5
