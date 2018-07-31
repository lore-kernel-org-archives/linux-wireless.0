Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55036 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731264AbeGaM2C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 08:28:02 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-07-31
Date: Tue, 31 Jul 2018 13:48:15 +0300
Message-ID: <87bmanadg0.fsf@kamboji.qca.qualcomm.com> (sfid-20180731_124827_112218_195F77B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

two small patches I still would like to get to the net tree for v4.18.
Please let me know if you have any problems.

Kalle


The following changes since commit 144fe2bfd236dc814eae587aea7e2af03dbdd755:

  sock: fix sg page frag coalescing in sk_alloc_sg (2018-07-23 21:28:45 -07=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git =
tags/wireless-drivers-for-davem-2018-07-31

for you to fetch changes up to 299b6365a3b7cf7f5ea1c945a420e9ee4841d6f7:

  brcmfmac: fix regression in parsing NVRAM for multiple devices (2018-07-2=
5 10:30:36 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.18

Last set of fixes before 4.18 is released

iwlwifi

* add new IDs for cards already available on the market

brcmfmac

* fix a regression introduced in v4.17

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: add more card IDs for 9000 series

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: fix regression in parsing NVRAM for multiple devices

 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      | 69 ++++++++++++++++++=
++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  5 ++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 22 +++++++
 4 files changed, 98 insertions(+), 1 deletion(-)

--=20
Kalle Valo
