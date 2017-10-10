Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29766 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755590AbdJJHxi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 03:53:38 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k-ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/5] Add TDLS feature for ath10k
Date: Tue, 10 Oct 2017 15:55:20 +0800
Message-ID: <1507622125-8841-2-git-send-email-yintang@qti.qualcomm.com> (sfid-20171010_095341_260928_D7FB55E5)
In-Reply-To: <1507622125-8841-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patch V4>
 <1507622125-8841-1-git-send-email-yintang@qti.qualcomm.com>
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
