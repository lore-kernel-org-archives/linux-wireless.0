Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailrelay119.isp.belgacom.be ([195.238.20.146]:46748 "EHLO
	mailrelay119.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbbCQSiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 14:38:07 -0400
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, Fabian Frederick <fabf@skynet.be>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	nios2-dev@lists.rocketboards.org, linuxppc-dev@lists.ozlabs.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 00/16 linux-next] drivers/net: constify of_device_id array
Date: Tue, 17 Mar 2015 19:37:31 +0100
Message-Id: <1426617469-781-1-git-send-email-fabf@skynet.be> (sfid-20150317_194416_008847_991E2FD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This small patchset adds const to of_device_id arrays in
drivers/net branch.

Fabian Frederick (16):
  net: netcp: constify of_device_id array
  Altera TSE: constify of_device_id array
  net/fsl: constify of_device_id array
  net: ethoc: constify of_device_id array
  drivers: net: xgene: constify of_device_id array
  net: ethernet: apple: constify of_device_id array
  netdev: octeon_mgmt: constify of_device_id array
  net: greth: constify of_device_id array
  net: xilinx: constify of_device_id array
  orinoco: constify of_device_id array
  net: phy: constify of_device_id array
  can: constify of_device_id array
  IBM-EMAC: constify of_device_id array
  ehea: constify of_device_id array
  net: via-rhine: constify of_device_id array
  via-velocity: constify of_device_id array

 drivers/net/can/cc770/cc770_platform.c                | 2 +-
 drivers/net/can/grcan.c                               | 2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                   | 2 +-
 drivers/net/can/sja1000/sja1000_platform.c            | 2 +-
 drivers/net/can/xilinx_can.c                          | 2 +-
 drivers/net/ethernet/aeroflex/greth.c                 | 2 +-
 drivers/net/ethernet/altera/altera_tse_main.c         | 4 ++--
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c      | 2 +-
 drivers/net/ethernet/apple/bmac.c                     | 2 +-
 drivers/net/ethernet/apple/mace.c                     | 2 +-
 drivers/net/ethernet/ethoc.c                          | 2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c          | 2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c      | 2 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c | 4 ++--
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c  | 2 +-
 drivers/net/ethernet/freescale/fs_enet/mii-fec.c      | 4 ++--
 drivers/net/ethernet/freescale/fsl_pq_mdio.c          | 2 +-
 drivers/net/ethernet/freescale/gianfar.c              | 2 +-
 drivers/net/ethernet/freescale/gianfar_ptp.c          | 2 +-
 drivers/net/ethernet/freescale/ucc_geth.c             | 2 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c           | 2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c             | 4 ++--
 drivers/net/ethernet/ibm/emac/core.c                  | 2 +-
 drivers/net/ethernet/ibm/emac/mal.c                   | 2 +-
 drivers/net/ethernet/ibm/emac/rgmii.c                 | 2 +-
 drivers/net/ethernet/ibm/emac/tah.c                   | 2 +-
 drivers/net/ethernet/ibm/emac/zmii.c                  | 2 +-
 drivers/net/ethernet/octeon/octeon_mgmt.c             | 2 +-
 drivers/net/ethernet/ti/netcp_core.c                  | 2 +-
 drivers/net/ethernet/via/via-rhine.c                  | 2 +-
 drivers/net/ethernet/via/via-velocity.c               | 2 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c           | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c     | 2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c         | 2 +-
 drivers/net/phy/mdio-bcm-unimac.c                     | 2 +-
 drivers/net/phy/mdio-gpio.c                           | 2 +-
 drivers/net/phy/mdio-mux-gpio.c                       | 2 +-
 drivers/net/phy/mdio-mux-mmioreg.c                    | 2 +-
 drivers/net/phy/mdio-octeon.c                         | 2 +-
 drivers/net/wireless/orinoco/airport.c                | 2 +-
 40 files changed, 44 insertions(+), 44 deletions(-)

-- 
2.1.0

