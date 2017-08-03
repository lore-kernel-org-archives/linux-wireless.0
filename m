Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751866AbdHCX7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 19:59:42 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: kvalo@codeaurora.org, gregkh@linuxfoundation.org
Cc: chunkeey@googlemail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 0/2] wireless: move prism54 to staging
Date: Thu,  3 Aug 2017 16:59:35 -0700
Message-Id: <20170803235937.8604-1-mcgrof@kernel.org> (sfid-20170804_020003_718680_503993B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle, Greg,

This moves the prism54 diver to staging. The reason for this are
stated on the driver's own commit log. Let me know what tree you'd
prefer this to go through.

Luis R. Rodriguez (2):
  wireless: move prism54 out to staging
  MAINTAINERS: update email address for mcgrof for few straggling
    drivers

 MAINTAINERS                                          |  8 ++++----
 drivers/net/wireless/intersil/Kconfig                | 20 --------------------
 drivers/net/wireless/intersil/Makefile               |  1 -
 drivers/staging/Kconfig                              |  2 ++
 drivers/staging/Makefile                             |  1 +
 .../wireless/intersil => staging}/prism54/Makefile   |  0
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
 21 files changed, 7 insertions(+), 25 deletions(-)
 rename drivers/{net/wireless/intersil => staging}/prism54/Makefile (100%)
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
