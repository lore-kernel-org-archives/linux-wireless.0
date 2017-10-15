Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0078.outbound.protection.outlook.com ([104.47.33.78]:11264
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751394AbdJOUxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Oct 2017 16:53:46 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH 0/8] qtnfmac: misc small features and fixes
Date: Sun, 15 Oct 2017 23:53:22 +0300
Message-Id: <20171015205327.9966-1-sergey.matyukevich.os@quantenna.com> (sfid-20171015_225418_943194_2ADDCE0E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle, Igor, and all

This patch series includes a number of small features and fixes
for qtnfmac driver.

Igor Mitsyanko (1):
 qtnfmac: advertise support of inactivity timeout

Sergey Matyukevich (4):
 qtnfmac: modify full Tx queue error reporting
 qtnfmac: enable registration of more mgmt frames
 qtnfmac: drop nonexistent function declaration
 qtnfmac: modify full Tx queue recovery


 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c            |   17 +++++++++++++++--
 drivers/net/wireless/quantenna/qtnfmac/commands.c            |    5 +++--
 drivers/net/wireless/quantenna/qtnfmac/core.c                |   27 +++++++++++++++++++++++++++
 drivers/net/wireless/quantenna/qtnfmac/core.h                |    4 +---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c          |   15 +++++++++------
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h |    1 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h               |   11 ++++++++++-
 7 files changed, 66 insertions(+), 14 deletions(-)
