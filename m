Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0070.outbound.protection.outlook.com ([104.47.38.70]:2209
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752473AbdJ3KOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Oct 2017 06:14:10 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Vasily Ulyanov <vulyanov@quantenna.com>
Subject: [PATCH v2 0/5] qtnfmac: misc small features and fixes
Date: Mon, 30 Oct 2017 13:13:45 +0300
Message-Id: <20171030101350.21251-1-sergey.matyukevich.os@quantenna.com> (sfid-20171030_111415_016342_178E4913)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle, Igor, and all

This patch series includes a number of small features and fixes
for qtnfmac driver.

Changes v1->v2:
Rebase on top of latest wireless-drivers-next to resolve the conflict
caused by qtnfmac fixes merged from wireless-drivers.

Igor Mitsyanko (1):
 qtnfmac: advertise support of inactivity timeout

Sergey Matyukevich (4):
 qtnfmac: modify full Tx queue error reporting
 qtnfmac: enable registration of more mgmt frames
 qtnfmac: drop nonexistent function declaration
 qtnfmac: modify full Tx queue recovery

 cfg80211.c            |   17 +++++++++++++++--
 commands.c            |    5 +++--
 core.c                |   27 +++++++++++++++++++++++++++
 core.h                |    4 +---
 pearl/pcie.c          |   15 +++++++++------
 pearl/pcie_bus_priv.h |    1 +
 qlink.h               |   11 ++++++++++-
 7 files changed, 66 insertions(+), 14 deletions(-)
