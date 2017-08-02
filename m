Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34932 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbdHBR5Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 13:57:24 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, harish.patil@cavium.com,
        manish.chopra@cavium.com, Dept-GELinuxNICDev@cavium.com
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 0/2] drivers/net: add const to bin_attribute structures
Date: Wed,  2 Aug 2017 23:27:12 +0530
Message-Id: <1501696634-15765-1-git-send-email-bhumirks@gmail.com> (sfid-20170802_195840_988581_A0BE8A39)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare bin_attribute structures as const.

Bhumika Goyal (2):
  wlcore: add const to bin_attribute structure
  qlcnic: add const to bin_attribute structure

 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c | 2 +-
 drivers/net/wireless/ti/wlcore/sysfs.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.9.1
