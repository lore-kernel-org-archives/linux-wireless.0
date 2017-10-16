Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44572 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdJPF6b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 01:58:31 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V6 0/5] Add TDLS feature for ath10k
Date: Mon, 16 Oct 2017 14:00:28 +0800
Message-ID: <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com> (sfid-20171016_075842_907216_519B7346)
In-Reply-To: <TDLS for ath10k patches V6>
References: <TDLS for ath10k patches V6>
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
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |    9 +++++
 drivers/net/wireless/ath/ath10k/wmi.h     |    1 +
 include/net/mac80211.h                    |    4 +++
 net/mac80211/tdls.c                       |    5 ++-
 6 files changed, 81 insertions(+), 2 deletions(-)

-- 
1.7.9.5
