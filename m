Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46906 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3HTRlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 13:41:32 -0400
Received: by mail-lb0-f179.google.com with SMTP id v1so706207lbd.24
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 10:41:31 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH 00/16] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
Date: Tue, 20 Aug 2013 19:41:03 +0200
Message-Id: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com> (sfid-20130820_194135_989973_6821547C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
far WCN3660/WCN3680 is available only on MSM platform.

To make review easier the driver sent in several patches, one patch per file, but after
review it will be sent as one big file.

Firmware can be found here:
https://github.com/AOKP/vendor_sony/find/jb-mr1

Wiki page is available here:
http://wireless.kernel.org/en/users/Drivers/wcn36xx

A lot people made a contribution to this driver. Her is the list in
alphabetical order:

Eugene Krasnikov <k.eugene.e@gmail.com>
Kalle Valo <kvalo@qca.qualcomm.com>
Olof Johansson <dev@skyshaper.net>
Pontus Fuchs <pontus.fuchs@gmail.com>
Yanbo Li <yanbol@qti.qualcomm.com>

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>

---

Eugene Krasnikov (16):
  wcn36xx: Add main.c
  wcn36xx: Add debug.c
  wcn36xx: Add debug.h
  wcn36xx: Add dxe.c
  wcn36xx: Add dxe.h
  wcn36xx: Add hal.h
  wcn36xx: Add pmc.c
  wcn36xx: Add pmc.h
  wcn36xx: Add smd.c
  wcn36xx: Add smd.h
  wcn36xx: Add txrx.c
  wcn36xx: Add txrx.h
  wcn36xx: Add wcn36xx.h
  wcn36xx: Add Makefile
  wcn36xx: Add Kconfig
  wcn36xx: Add wcn36xx to ath Makefile and Kconfig

 drivers/net/wireless/ath/Kconfig           |    1 +
 drivers/net/wireless/ath/Makefile          |    1 +
 drivers/net/wireless/ath/wcn36xx/Kconfig   |   16 +
 drivers/net/wireless/ath/wcn36xx/Makefile  |    9 +
 drivers/net/wireless/ath/wcn36xx/debug.c   |  164 +
 drivers/net/wireless/ath/wcn36xx/debug.h   |   49 +
 drivers/net/wireless/ath/wcn36xx/dxe.c     |  802 +++++
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  281 ++
 drivers/net/wireless/ath/wcn36xx/hal.h     | 4657 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/main.c    | 1034 ++++++
 drivers/net/wireless/ath/wcn36xx/pmc.c     |   44 +
 drivers/net/wireless/ath/wcn36xx/pmc.h     |   32 +
 drivers/net/wireless/ath/wcn36xx/smd.c     | 1530 +++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h     |  121 +
 drivers/net/wireless/ath/wcn36xx/txrx.c    |  261 ++
 drivers/net/wireless/ath/wcn36xx/txrx.h    |  160 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  239 ++
 17 files changed, 9401 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/Kconfig
 create mode 100644 drivers/net/wireless/ath/wcn36xx/Makefile
 create mode 100644 drivers/net/wireless/ath/wcn36xx/debug.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/debug.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/dxe.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/dxe.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/hal.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/main.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/pmc.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/smd.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/smd.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/txrx.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/txrx.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/wcn36xx.h

-- 
1.8.2.2

