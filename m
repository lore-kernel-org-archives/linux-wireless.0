Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41475 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcFDPp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2016 11:45:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2016-06-04
Date: Sat, 04 Jun 2016 18:45:21 +0300
Message-ID: <87shwtrm9a.fsf@kamboji.qca.qualcomm.com> (sfid-20160604_174557_177032_E5041270)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

few fixes for 4.7. Please let me know if you have any issues.

Kalle

The following changes since commit b7e7ad611e24b95b0db2998428ce78370415c086:

  Merge branch 'qed-fixes' (2016-05-26 12:27:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2016-06-04

for you to fetch changes up to 182fd9eecb287e696c82b30d06c6150d80a49c5b:

  MAINTAINERS: Add file patterns for wireless device tree bindings (2016-06-04 17:24:02 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.7

brcmfmac

* add fallback RSSI report for devices that do not report per-chain values
* fix a null pointer derefence regression on PCIe full dongle devices

rtlwifi

* fix scheduling while atomic regression from commit 49f86ec21c01

MAINTAINERS

* add file patterns for wireless device tree bindings

----------------------------------------------------------------
Franky Lin (1):
      brcmfmac: add eth_type_trans back for PCIe full dongle

Geert Uytterhoeven (1):
      MAINTAINERS: Add file patterns for wireless device tree bindings

Jaap Jan Meijer (1):
      brcmfmac: add fallback for devices that do not report per-chain values

Larry Finger (1):
      rtlwifi: Fix scheduling while atomic error from commit 49f86ec21c01

 MAINTAINERS                                        |    1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   16 ++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    2 ++
 drivers/net/wireless/realtek/rtlwifi/core.c        |    6 +++---
 4 files changed, 22 insertions(+), 3 deletions(-)
