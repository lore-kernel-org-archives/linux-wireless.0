Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:34663 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbeHCMwM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 08:52:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/3] staging: wilc1000: updated copyright header and TODO list
Date: Fri, 3 Aug 2018 16:26:12 +0530
Message-ID: <1533293775-22456-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180803_125629_573208_FEC6ADBD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains the remaining patches from [1]. Included the
updated copyright information for all source and header file.
Also included the patch to remove checkpatch error and updated the TODO item.
After this patch only 3 checkpatch related warning are remaining(2 will be
remove after moving binding reference to './Documentation/devicetree/bindings/'

./drivers/staging/wilc1000/wilc_sdio.c:211: WARNING: DT compatible string
"microchip,wilc1000-sdio" appears un-documented
./drivers/staging/wilc1000/wilc_spi.c:142: WARNING: DT compatible string
"microchip,wilc1000-spi" appears un-documented

./drivers/staging/wilc1000/wilc_wlan.c:438: CHECK: usleep_range is preferred
over udelay;

[1]. https://www.spinics.net/lists/linux-driver-devel/msg115571.html

Ajay Singh (3):
  staging: wilc1000: added Microchip copyright notice header
  staging: wilc1000: replace ISWILC1000() macro with inline function
  staging: wilc1000: remove TODO item for comments and code style

 drivers/staging/wilc1000/TODO                     |  1 -
 drivers/staging/wilc1000/coreconfigurator.c       |  5 +++++
 drivers/staging/wilc1000/coreconfigurator.h       |  5 +++++
 drivers/staging/wilc1000/host_interface.c         |  5 +++++
 drivers/staging/wilc1000/host_interface.h         |  5 +++++
 drivers/staging/wilc1000/linux_mon.c              |  5 +++++
 drivers/staging/wilc1000/linux_wlan.c             |  5 +++++
 drivers/staging/wilc1000/wilc_debugfs.c           | 10 ++--------
 drivers/staging/wilc1000/wilc_sdio.c              |  5 ++---
 drivers/staging/wilc1000/wilc_spi.c               |  5 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  5 +++++
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  5 +++++
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  5 +++++
 drivers/staging/wilc1000/wilc_wlan.c              | 14 ++++++++++++--
 drivers/staging/wilc1000/wilc_wlan.h              |  7 +++++--
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 12 ++++--------
 drivers/staging/wilc1000/wilc_wlan_cfg.h          | 12 ++++--------
 drivers/staging/wilc1000/wilc_wlan_if.h           | 12 ++++--------
 18 files changed, 80 insertions(+), 43 deletions(-)

-- 
2.7.4
