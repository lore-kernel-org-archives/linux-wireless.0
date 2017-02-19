Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53546 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750880AbdBSTAo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 14:00:44 -0500
Received: from server.home ([194.96.34.35]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MUHbK-1colqf44d0-00Qyh5 for
 <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 20:00:32 +0100
Received: from homeserver.home (localhost [127.0.0.1])
        by server.home (Postfix) with ESMTP id 2F66D1C0A26
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 20:00:31 +0100 (CET)
Subject: Re: brcmfmac: BCM4343A0 P2P mode problem
From: =?utf-8?Q?Stefan_Holzmann?= <stefan.holzmann@gmx.net>
To: =?utf-8?Q?linux-wireless=40vger=2Ekernel=2Eorg?=
        <linux-wireless@vger.kernel.org>
Date: Sun, 19 Feb 2017 20:00:31 +0100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.58a9eb4f.3258.65a3ba3c60add992@homeserver.home> (sfid-20170219_200054_149627_556C7670)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I think my problem was just a firmware version issue. When I use the firmware file "fw_bcm4343.bin" from here https://android.googlesource.com/platform/hardware/broadcom/wlan I'am able establish a P2P connection.
Is this the latest/recommended firmware version for the chipset?

Firmware version = wl0: Jul  1 2016 18:02:40 version 7.10.1 (A0 Station/P2P feature) FWID 01-bae8afee


>Thank you for your support. Yes, correct SDIO 0xA9A6 is BCM43430 I was confused by 
>the naming of some firmware files.

>What firmware version/file shall be used for this chipset/driver combination?
>Currently I'am using the firmware file "fw_bcm43438a0_p2p.bin" from here 
>https://github.com/BPI-SINOVOIP/BPI_WiFi_Firmware/tree/master/ap6212.

>I have set the driver parameter "use_p2p_group_interface=1" as you recommended, and 
>now I see following error messages at the kernel log when I try to setup a P2P 
>connection.
>
>[   59.593565] brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
>[   62.163452] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
>[   62.169542] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
>[   62.175839] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-wlan0-0 type 8 
>failed: err=-110
