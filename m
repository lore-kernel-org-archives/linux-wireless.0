Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:32939 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbeCNMpR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 08:45:17 -0400
From: hariprasath.elango@gmail.com
To: aditya.shankar@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com
Cc: hariprasath.elango@gmail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Cleanup patches for wilc1000 driver
Date: Wed, 14 Mar 2018 18:14:58 +0530
Message-Id: <cover.1521030891.git.hariprasath.elango@gmail.com> (sfid-20180314_134717_618518_53FFA130)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: HariPrasath Elango <hariprasath.elango@gmail.com>

This patchset has few cleanup patches related to coding guidelines and few
trivial changes

HariPrasath Elango (7):
  staging: wilc1000: Fix code block alignment
  staging: wilc1000: Destroy mutex object in deinitialization
  staging: wilc1000: use kmemdup instead of kmalloc and memcpy
  staging: wilc1000: destroy initialized mutex object
  staging: wilc1000: replace switch statement by simple if condition
  staging: wilc1000: remove unwanted braces and correct code alignment
  staging: wilc1000: use kmemdup to replace kmalloc/memcpy

 drivers/staging/wilc1000/host_interface.c         | 27 +++++++++++++----------
 drivers/staging/wilc1000/linux_mon.c              |  3 +--
 drivers/staging/wilc1000/linux_wlan.c             |  7 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  9 ++------
 4 files changed, 22 insertions(+), 24 deletions(-)

-- 
2.10.0.GIT
