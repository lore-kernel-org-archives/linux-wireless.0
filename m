Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:14424 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdISCt7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 22:49:59 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [TDLS PATCH V2 0/5] Add TDLS feature for ath10k
Date: Tue, 19 Sep 2017 10:51:03 +0800
Message-ID: <1505789468-25330-1-git-send-email-yintang@qti.qualcomm.com> (sfid-20170919_045002_711617_C480B1AE)
In-Reply-To: <TDLS for ath10k patchset v2>
References: <TDLS for ath10k patchset v2>
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
