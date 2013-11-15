Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55483 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab3KONsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 08:48:11 -0500
Date: Fri, 15 Nov 2013 05:47:52 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: "Proffit, Jerome" <jproffit@qca.qualcomm.com>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Biard, David" <dbiard@qca.qualcomm.com>,
	<ath9k_htc_fw@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc: Target is unresponsive
Message-ID: <20131115134752.GQ9795@pogo> (sfid-20131115_144831_223701_B0A5D99E)
References: <39E4555519E9C54593B1BE31E24CB79A39B12884@nasanexd02a.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <39E4555519E9C54593B1BE31E24CB79A39B12884@nasanexd02a.na.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc'ing linux-wireless and ath9k_htc_fw list. The firmware is open
so any issues can now be debugged in collaboration with the community.

You may try the newer backports:

http://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.12/backports-3.12-1.tar.bz2

And as for the firmware it seems to be the latest but I'll let
others who are maintaining that now chime in.

  Luis

On Fri, Nov 15, 2013 at 02:17:43AM -0800, Proffit, Jerome wrote:
> Hello,
> 
> Could anybody help with the question below?
> 
> Thanks,
> 
> -Jerome
> 
> -------------------------------------------
> 
> We are trying to bring up the VIA TECH WLAN USB dongle (AR9271 based
> chip) on our platform.  We have downloaded the back port
> drivers from:
> https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.10/backports-3.10-1.tar.bz2
> and cross compiled to our target (Tensilica -233).  The Firmware
> (htc_9271.fw) is downloaded from:
> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw and copied
> the same into /lib/firmware/ on the target.  Loaded all generated
> modules (.ko) and connect the WiFi over USB dongle into the USB
> connector. But the device is not getting initialized. Please find the
> log as below. Please help in this regard.
> 
> 
> Log:
> usb 1-1: new high speed USB device using dwc_otg and address 2
> usb 1-1: configuration #1 chosen from 1 choice
> usb 1-1: ath9k_htc: Firmware htc_9271.fw requested
> usb 1-1: firmware: requesting htc_9271.fw
> usb 1-1: ath9k_htc: Transferred FW: htc_9271.fw, size: 51000
> ath9k_htc 1-1:1.0: ath9k_htc: Target is unresponsive
> ath9k_htc: Failed to initialize the device
> 
> 
> Product:VIA USB2.0 WLAN
> Manufacturer:VIA TECH
> 
> Vendor id: 0x040d 
> Product id: 0x3801
> ----------------------------------------
> 
> 
