Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49698 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3H1H5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 03:57:37 -0400
Received: by mail-lb0-f177.google.com with SMTP id p5so3430483lbi.36
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 00:57:36 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v3 00/16] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
Date: Wed, 28 Aug 2013 09:56:30 +0200
Message-Id: <1377676606-23033-1-git-send-email-k.eugene.e@gmail.com> (sfid-20130828_095740_944969_6485296B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a mac80211 driver for Qualcomm WCN3660/WCN3680 devices. So
far WCN3660/WCN3680 is available only on MSM platform.

During second round some dead code was found. Functionality was not changed
after second review.

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
  wcn36xx: add main.c
  wcn36xx: add debug.c
  wcn36xx: add debug.h
  wcn36xx: add dxe.c
  wcn36xx: add dxe.h
  wcn36xx: add hal.h
  wcn36xx: add pmc.c
  wcn36xx: add pmc.h
  wcn36xx: add smd.c
  wcn36xx: add smd.h
  wcn36xx: add txrx.c
  wcn36xx: add txrx.h
  wcn36xx: add wcn36xx.h
  wcn36xx: add Makefile
  wcn36xx: add Kconfig
  wcn36xx: Add wcn36xx to ath Makefile and Kconfig

 drivers/net/wireless/ath/Kconfig           |    1 +
 drivers/net/wireless/ath/Makefile          |    1 +
 drivers/net/wireless/ath/wcn36xx/Kconfig   |   16 +
 drivers/net/wireless/ath/wcn36xx/Makefile  |    9 +
 drivers/net/wireless/ath/wcn36xx/debug.c   |  166 +
 drivers/net/wireless/ath/wcn36xx/debug.h   |   49 +
 drivers/net/wireless/ath/wcn36xx/dxe.c     |  804 +++++
 drivers/net/wireless/ath/wcn36xx/dxe.h     |  281 ++
 drivers/net/wireless/ath/wcn36xx/hal.h     | 4657 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wcn36xx/main.c    | 1035 +++++++
 drivers/net/wireless/ath/wcn36xx/pmc.c     |   46 +
 drivers/net/wireless/ath/wcn36xx/pmc.h     |   32 +
 drivers/net/wireless/ath/wcn36xx/smd.c     | 1530 +++++++++
 drivers/net/wireless/ath/wcn36xx/smd.h     |  121 +
 drivers/net/wireless/ath/wcn36xx/txrx.c    |  256 ++
 drivers/net/wireless/ath/wcn36xx/txrx.h    |  160 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  236 ++
 17 files changed, 9400 insertions(+)
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

