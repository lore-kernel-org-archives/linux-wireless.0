Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33874 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdAMFhD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 00:37:03 -0500
Received: by mail-pf0-f172.google.com with SMTP id 127so25129767pfg.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 21:37:02 -0800 (PST)
From: Matt Ranostay <matt@ranostay.consulting>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Cc: tony@atomide.com, Matt Ranostay <matt@ranostay.consulting>
Subject: [PATCH v3 0/2]  mmc: pwrseq: add support for Marvell SD8787 chip
Date: Thu, 12 Jan 2017 21:29:12 -0800
Message-Id: <20170113052914.12400-1-matt@ranostay.consulting> (sfid-20170113_063712_113307_A101B55E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v1:
* split devictree docs from pwrseq changes
* rebase devicetree documents due to filename change
* rebase pwrseq patchset

Changes from v2:
* fix rookie mistake missing the main source file and docs

Matt Ranostay (2):
  devicetree: document new marvell-8xxx and pwrseq-sd8787 options
  mmc: pwrseq: add support for Marvell SD8787 chip

 .../devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt  |  14 +++
 .../bindings/net/wireless/marvell-8xxx.txt         |   7 +-
 drivers/mmc/core/Kconfig                           |  10 ++
 drivers/mmc/core/Makefile                          |   1 +
 drivers/mmc/core/pwrseq_sd8787.c                   | 117 +++++++++++++++++++++
 5 files changed, 148 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/mmc/mmc-pwrseq-sd8787.txt
 create mode 100644 drivers/mmc/core/pwrseq_sd8787.c

-- 
2.10.2
