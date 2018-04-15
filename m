Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:39317 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752493AbeDOMWt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Apr 2018 08:22:49 -0400
Received: by mail-lf0-f67.google.com with SMTP id p142-v6so18241210lfd.6
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2018 05:22:48 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 0/2] ath10k: HTT ops wrappers
Date: Sun, 15 Apr 2018 14:22:26 +0200
Message-Id: <20180415122228.12565-1-erik.stromdahl@gmail.com> (sfid-20180415_142253_803483_848C8BE0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These two patches were included in the High latency v4 RFC
submitted a few months ago.

I think it would be appropriate to add them separately since
they are not really related to the HL patches.

This will make the next HL patch set somewhat smaller.

Erik Stromdahl (2):
  ath10k: add inlined wrappers for htt tx ops
  ath10k: add inlined wrappers for htt rx ops

 drivers/net/wireless/ath/ath10k/htt.c    |  4 +-
 drivers/net/wireless/ath/ath10k/htt.h    | 88 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c | 14 ++--
 drivers/net/wireless/ath/ath10k/htt_tx.c | 12 ++--
 drivers/net/wireless/ath/ath10k/mac.c    |  2 +-
 5 files changed, 104 insertions(+), 16 deletions(-)

-- 
2.17.0
