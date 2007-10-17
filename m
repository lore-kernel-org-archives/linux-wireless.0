Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbXJQOMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 10:12:18 -0400
Subject: Re: iwl3945 doesn't work
From: Dan Williams <dcbw@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20071017135452.GJ5043@kernel.dk>
References: <20071017135452.GJ5043@kernel.dk>
Content-Type: text/plain
Date: Wed, 17 Oct 2007 10:11:11 -0400
Message-Id: <1192630271.10567.32.camel@localhost.localdomain> (sfid-20071017_151220_313358_F440744A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-10-17 at 15:54 +0200, Jens Axboe wrote:
> Hi,
> 
> Seeing that iwl3945 is now merged, I decided to switch my x60 to use
> that instead of ipw3945. That would leave me with zero kernel
> dependencies.
> 
> Unfortunately it doesn't work. Loading the module reveals the device:
> 
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for
> Linux, 1.1.17ks
> iwl3945: Copyright(c) 2003-2007 Intel Corporation
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 21
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
> phy0: Selected rate control algorithm 'iwl-3945-rs'
> 
> # iwconfig wlan0
> wlan0     IEEE 802.11g  ESSID:"xxxxxxxxxxxxxx"  
>           Mode:Managed  Channel:0  Access Point: Not-Associated   
>           Tx-Power=0 dBm   
>           Retry min limit:7   RTS thr:off   Fragment thr=2346 B   
>           Encryption key:XXXX-XXXX-XX
>           Link Quality:0  Signal level:0  Noise level:0
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> 
> and iwconfig sees it, essid/enc settings are fine, but I don't get a
> link.

You do have the updated firmware, right?  I don't think iwl3945 would
even load if you didn't, but it doesn't hurt to check.

Also, what exact kernel version are you using?  2.6.23 release kernel?
Or something from development series?

Dan

