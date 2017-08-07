Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751743AbdHGWaO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 18:30:14 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: gregkh@linuxfoundation.org
Cc: kvalo@codeaurora.org, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 0/2] prism54: move to staging
Date: Mon,  7 Aug 2017 15:30:09 -0700
Message-Id: <20170807223011.21926-1-mcgrof@kernel.org> (sfid-20170808_003058_681633_450FFFBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg,

This v2 adds the TODO you requested to clarify prism54 will be removed in
two kernel releases from now, and so no further cleanup is needed other
than to ensure the driver compiles.

This is based on linux-next tag next-20170807.

  Luis

Luis R. Rodriguez (2):
  wireless: move prism54 out to staging
  MAINTAINERS: update email address for mcgrof for few straggling
    drivers

  Luis

 MAINTAINERS                                          |  8 ++++----
 drivers/net/wireless/intersil/Kconfig                | 20 --------------------
 drivers/net/wireless/intersil/Makefile               |  1 -
 drivers/staging/Kconfig                              |  2 ++
 drivers/staging/Makefile                             |  1 +
 .../wireless/intersil => staging}/prism54/Makefile   |  0
 drivers/staging/prism54/TODO                         |  5 +++++
 .../wireless/intersil => staging}/prism54/isl_38xx.c |  0
 .../wireless/intersil => staging}/prism54/isl_38xx.h |  0
 .../intersil => staging}/prism54/isl_ioctl.c         |  0
 .../intersil => staging}/prism54/isl_ioctl.h         |  0
 .../wireless/intersil => staging}/prism54/isl_oid.h  |  0
 .../intersil => staging}/prism54/islpci_dev.c        |  0
 .../intersil => staging}/prism54/islpci_dev.h        |  0
 .../intersil => staging}/prism54/islpci_eth.c        |  0
 .../intersil => staging}/prism54/islpci_eth.h        |  0
 .../intersil => staging}/prism54/islpci_hotplug.c    |  0
 .../intersil => staging}/prism54/islpci_mgt.c        |  0
 .../intersil => staging}/prism54/islpci_mgt.h        |  0
 .../wireless/intersil => staging}/prism54/oid_mgt.c  |  0
 .../wireless/intersil => staging}/prism54/oid_mgt.h  |  0
 .../intersil => staging}/prism54/prismcompat.h       |  0
 22 files changed, 12 insertions(+), 25 deletions(-)
 rename drivers/{net/wireless/intersil => staging}/prism54/Makefile (100%)
 create mode 100644 drivers/staging/prism54/TODO
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_38xx.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_38xx.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_ioctl.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_ioctl.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/isl_oid.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_dev.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_dev.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_eth.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_eth.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_hotplug.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_mgt.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/islpci_mgt.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/oid_mgt.c (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/oid_mgt.h (100%)
 rename drivers/{net/wireless/intersil => staging}/prism54/prismcompat.h (100%)

-- 
2.11.0
