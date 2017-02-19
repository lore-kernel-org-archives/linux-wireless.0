Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:60566 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750760AbdBSIE0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 03:04:26 -0500
MIME-Version: 1.0
Message-ID: <trinity-bf644a9e-0ef3-4063-afe1-57653b456ca6-1487491411828@3capp-gmx-bs10> (sfid-20170219_091206_997335_89B0036B)
From: "Stefan Holzmann" <stefan.holzmann@gmx.net>
To: linux-wireless@vger.kernel.org
Subject: Re: brcmfmac: BCM4343A0 P2P mode problem
Content-Type: text/plain; charset=UTF-8
Date: Sun, 19 Feb 2017 09:03:31 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you for your support. Yes, correct SDIO 0xA9A6 is BCM43430 I was confused by the naming of some firmware files.

What firmware version/file shall be used for this chipset/driver combination?
Currently I'am using the firmware file "fw_bcm43438a0_p2p.bin" from here https://github.com/BPI-SINOVOIP/BPI_WiFi_Firmware/tree/master/ap6212.

I have set the driver parameter "use_p2p_group_interface=1" as you recommended, and now I see following error messages at the kernel log when I try to setup a P2P connection.

[   59.593565] brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
[   62.163452] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
[   62.169542] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
[   62.175839] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-wlan0-0 type 8 failed: err=-110
