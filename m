Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53412 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZAEXKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 18:10:51 -0500
Received: from [192.168.1.194] (S0106001cf062885c.vc.shawcable.net [24.82.150.230])
	by mail.holtmann.org (Postfix) with ESMTP id 52A2C8B547
	for <linux-wireless@vger.kernel.org>; Tue,  6 Jan 2009 00:10:51 +0100 (CET)
Subject: iwlagn: Microcode SW error detected.  Restarting 0x2000000
From: Marcel Holtmann <marcel@holtmann.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 06 Jan 2009 00:10:48 +0100
Message-Id: <1231197048.4858.9.camel@californication> (sfid-20090106_001054_849135_F9C407C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

so I am running into this one on my X61:

iwlagn 0000:03:00.0: PCI INT A disabled
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27k
iwlagn: Copyright(c) 2003-2008 Intel Corporation
vendor=8086 device=2841
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
wmaster0 (iwlagn): not using net_device_ops yet
phy1: Selected rate control algorithm 'iwl-agn-rs'
wlan0 (iwlagn): not using net_device_ops yet
vendor=8086 device=2841
iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
iwlagn loaded firmware version 228.57.2.23
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwlagn: Microcode SW error detected.  Restarting 0x2000000.

It renders the wireless device useless and module unload/reload doesn't
help either. Is this the AMT issue again or something totally different
with the latest ucode?

This machine is running Linus' tip from today. I am currently not
running wireless-testing since it is not synced up with Linus tree at
the moment.

Regards

Marcel


