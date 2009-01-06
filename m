Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56286 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbZAFBOr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 20:14:47 -0500
Subject: Re: iwlagn: Microcode SW error detected.  Restarting 0x2000000
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1231197048.4858.9.camel@californication>
References: <1231197048.4858.9.camel@californication>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 09:13:40 +0800
Message-Id: <1231204420.11581.24.camel@debian> (sfid-20090106_021454_737988_45FFB226)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-06 at 07:10 +0800, Marcel Holtmann wrote:
> iwlagn 0000:03:00.0: PCI INT A disabled
> iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27k
> iwlagn: Copyright(c) 2003-2008 Intel Corporation
> vendor=8086 device=2841
> iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:03:00.0: setting latency timer to 64
> iwlagn: Detected Intel Wireless WiFi Link 4965AGN REV=0x4
> iwlagn: Tunable channels: 11 802.11bg, 13 802.11a channels
> wmaster0 (iwlagn): not using net_device_ops yet
> phy1: Selected rate control algorithm 'iwl-agn-rs'
> wlan0 (iwlagn): not using net_device_ops yet
> vendor=8086 device=2841
> iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwlagn 0000:03:00.0: firmware: requesting iwlwifi-4965-2.ucode
> iwlagn loaded firmware version 228.57.2.23
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> iwlagn: Microcode SW error detected.  Restarting 0x2000000.
> 
> It renders the wireless device useless and module unload/reload
> doesn't
> help either. Is this the AMT issue again or something totally
> different with the latest ucode?

Not sure. Marcel, please load iwlagn with debug=0x43fff. We can then
track the uCode failure.

Thanks,
-yi


