Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36150 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdAMFWW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 00:22:22 -0500
Received: by mail-pf0-f173.google.com with SMTP id 189so25195037pfu.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2017 21:22:22 -0800 (PST)
From: Matt Ranostay <matt@ranostay.consulting>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org
Cc: tony@atomide.com, Matt Ranostay <matt@ranostay.consulting>
Subject: [PATCH v2 0/2] mmc: pwrseq: add support for Marvell SD8787 chip
Date: Thu, 12 Jan 2017 21:22:16 -0800
Message-Id: <20170113052218.10534-1-matt@ranostay.consulting> (sfid-20170113_062251_299229_407BABDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes from v1:
* split devictree docs from pwrseq changes
* rebase devicetree documents due to filename change
* rebase pwrseq patchset

Matt Ranostay (2):
  devicetree: document vmmc-supply and mmc-pwrseq options
  mmc: pwrseq: add support for Marvell SD8787 chip

 .../devicetree/bindings/net/wireless/marvell-8xxx.txt          |  7 ++++++-
 drivers/mmc/core/Kconfig                                       | 10 ++++++++++
 drivers/mmc/core/Makefile                                      |  1 +
 3 files changed, 17 insertions(+), 1 deletion(-)

-- 
2.10.2
