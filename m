Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:38045 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbeAVKWx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 05:22:53 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 00/14] fix to remove unnecessary parenthesis,typedef and avoid camelCase
Date: Mon, 22 Jan 2018 15:52:13 +0530
Message-ID: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180122_112257_415644_CE1D90ED)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to fix issues reported by checkpatch.pl script.

Changes since v1:
* Patch0004: Used "host_int_parse_join_bss_param" for function name.
* Patch0009: Put memcpy statement in single line instead of using two lines.
* Patch0010: Used "bss_param" for variable name instead of j_bss_param.
* Added "Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>" for commit description.
* Modify the commit description to start with capital letter for all patch.


Ajay Singh (14):
  staging: wilc1000: remove unnecessary use of parentheses
  staging: wilc1000: removed unnecessary defined enums typedef
  staging: wilc1000: fix alignments to match open parenthesis
  staging: wilc1000: rename host_int_ParseJoinBssParam() and it's
    variable using camelCase
  staging: wilc1000: rename camelCase used in Handle_DelAllSta() and its
    variable
  staging: wilc1000: rename strWIDList variable to wid_list to avoid
    camelCase
  staging: wilc1000: rename u32WidsCount variable to avoid camelCase
  staging: wilc1000: rename pu8CurrByte variable to avoid camelCase
  staging: wilc1000: rename pstrHostIFconnectAttr argument to avoid
    camelCase
  staging: wilc1000: rename ptstrJoinBssParam variable to avoid
    camelCase
  staging: wilc1000: rename strConnectInfo variable to avoid camelCase
  staging: wilc1000: rename Handle_ScanDone() to avoid camelCase
  staging: wilc1000: rename Handle_Connect() to avoid camelCase
  staging: wilc1000: rename Handle_ConnectTimeout() and Handle_Key()

 drivers/staging/wilc1000/coreconfigurator.c       |   2 +-
 drivers/staging/wilc1000/host_interface.c         | 937 +++++++++++-----------
 drivers/staging/wilc1000/linux_wlan.c             |  10 +-
 drivers/staging/wilc1000/wilc_sdio.c              |   4 +-
 drivers/staging/wilc1000/wilc_spi.c               |  20 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  64 +-
 drivers/staging/wilc1000/wilc_wlan.c              |   2 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          |   6 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |  72 +-
 9 files changed, 555 insertions(+), 562 deletions(-)

-- 
2.7.4
