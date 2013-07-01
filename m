Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57251 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab3GAUz0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 16:55:26 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] backports: backport alx
Date: Mon,  1 Jul 2013 13:55:17 -0700
Message-Id: <1372712120-16606-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130701_225529_112852_15F3046E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

Johannes threw alx upstream, this fixes the backport based on
the new shiny code.

Luis R. Rodriguez (3):
  backports: remove alx extra patch
  backports: add new alx upstream backport
  backports: add SPEED_UNKNOWN and DUPLEX_UNKNOWN

 backport/backport-include/linux/ethtool.h          |    8 ++
 .../network/0001-netdev_ops/alx.patch              |   11 ++
 .../network/0001-netdev_ops/mwifiex.patch          |    2 +-
 .../network/0007-pci_dev_dev_flags/INFO            |   28 +++++
 .../network/0007-pci_dev_dev_flags/alx.patch       |   13 +++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   24 ++++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   14 +++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   58 +++++++++
 .../drivers_net_ethernet_atheros_alx_main.patch    |   13 +++
 ...drivers_net_wireless_rtlwifi_rtl8192cu_sw.patch |    2 +-
 .../network/0001-backport-alx/alx.patch            |  123 --------------------
 .../network/0002-alx-make-kconfig/alx.patch        |   32 -----
 .../0003-alx-deactivate-loopback-test/alx.patch    |   25 ----
 13 files changed, 171 insertions(+), 182 deletions(-)
 create mode 100644 patches/collateral-evolutions/network/0001-netdev_ops/alx.patch
 create mode 100644 patches/collateral-evolutions/network/0007-pci_dev_dev_flags/INFO
 create mode 100644 patches/collateral-evolutions/network/0007-pci_dev_dev_flags/alx.patch
 create mode 100644 patches/collateral-evolutions/network/11-dev-pm-ops/drivers_net_ethernet_atheros_alx_main.patch
 create mode 100644 patches/collateral-evolutions/network/25-multicast-list_head/drivers_net_ethernet_atheros_alx_main.patch
 create mode 100644 patches/collateral-evolutions/network/40-netdev-hw-features/drivers_net_ethernet_atheros_alx_main.patch
 create mode 100644 patches/collateral-evolutions/network/61-netdev-addr_assign_type/drivers_net_ethernet_atheros_alx_main.patch
 delete mode 100644 patches/unified-drivers/network/0001-backport-alx/alx.patch
 delete mode 100644 patches/unified-drivers/network/0002-alx-make-kconfig/alx.patch
 delete mode 100644 patches/unified-drivers/network/0003-alx-deactivate-loopback-test/alx.patch

-- 
1.7.10.4

