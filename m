Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:39242 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751898AbYJTMRN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 08:17:13 -0400
Date: Mon, 20 Oct 2008 14:17:10 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Dieter Ries <clip2@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945 broken in current git
Message-ID: <20081020121710.GA3607@isilmar.linta.de> (sfid-20081020_141718_690091_E56EF8AB)
References: <48FC6C05.6020901@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48FC6C05.6020901@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 01:31:17PM +0200, Dieter Ries wrote:
> Hi,
> 
> with latest git I cannot use my intel 3945 wifi. It shows up in
> ifconfig, but it just does not work.
> 
> dmesg output is:
> 
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for
> Linux, 1.2.26ks
> iwl3945: Copyright(c) 2003-2008 Intel Corporation
> iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwl3945 0000:03:00.0: setting latency timer to 64
> iwl3945: Detected Intel Wireless WiFi Link 3945ABG
> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> phy1: Selected rate control algorithm 'iwl-3945-rs'
> iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-1.ucode
> Registered led device: iwl-phy1:radio
> Registered led device: iwl-phy1:assoc
> Registered led device: iwl-phy1:RX
> Registered led device: iwl-phy1:TX
> ADDRCONF(NETDEV_UP): wlan0: link is not ready
> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
> 0x4416 ser 0x0000004B
> iwl3945: Can't stop Rx DMA.

It needs a more recent uCode -- the driver really should scream out loudly
that the old firmware no longer suffices.

Best,
	Dominik
