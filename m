Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbdBFPU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 10:20:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2017-02-06
Date: Mon, 06 Feb 2017 17:19:52 +0200
Message-ID: <874m07ny7b.fsf@kamboji.qca.qualcomm.com> (sfid-20170206_162135_145844_F8B34FEA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

one more fix I still would like to get to 4.10 if possible. Please let
me know if there are any problems.

Kalle

The following changes since commit 2b1d530cb3157f828fcaadd259613f59db3c6d1c:

  MAINTAINERS: ath9k-devel is closed (2017-01-28 09:15:50 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2017-02-06

for you to fetch changes up to 52f5631a4c056ad01682393be56d2be237e81610:

  rtlwifi: rtl8192ce: Fix loading of incorrect firmware (2017-01-31 09:05:25 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.10

Only one important fix for rtlwifi which fixes a regression introduced
in 4.9 and which caused problems for many users.

----------------------------------------------------------------
Jurij Smakov (1):
      rtlwifi: rtl8192ce: Fix loading of incorrect firmware

 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)
