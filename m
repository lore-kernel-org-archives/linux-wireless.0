Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:41133 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdL1THo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 14:07:44 -0500
Received: by mail-lf0-f68.google.com with SMTP id h137so1975803lfe.8
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 11:07:43 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 0/3] ath10k: a few minor fixes
Date: Thu, 28 Dec 2017 20:06:42 +0100
Message-Id: <20171228190645.25773-1-erik.stromdahl@gmail.com> (sfid-20171228_200748_737005_6A033E22)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I discovered these issues while working with the next round of
patches for High Latency devices.

In order to reduce the size of that patchset, I think it is best
if these patches could be added in advance.

The last patch fixes an actual bug that was introduced in
commit 71e9c29fbd28ec14bb8f920c7afd515a75c00234

The other two are just cleanups.

Erik Stromdahl (3):
  ath10k: fix spelling error
  ath10k: remove unused prototype
  ath10k: bugfix: add USB case in ath10k_core_probe_fw

 drivers/net/wireless/ath/ath10k/core.c | 1 +
 drivers/net/wireless/ath/ath10k/htt.h  | 1 -
 drivers/net/wireless/ath/ath10k/wmi.h  | 2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.15.1
