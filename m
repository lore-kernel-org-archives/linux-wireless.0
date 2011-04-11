Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52738 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1DKPZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 11:25:43 -0400
Received: by iwn34 with SMTP id 34so5722027iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2011 08:25:43 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19875.7684.859710.807182@gargle.gargle.HOWL>
Date: Mon, 11 Apr 2011 20:58:04 +0530
To: Richard Farina <sidhayn@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc oddity
In-Reply-To: <4DA311F3.6010007@gmail.com>
References: <4D9FCC70.1020805@gmail.com>
	<19871.62035.829719.402615@gargle.gargle.HOWL>
	<4DA311F3.6010007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> The following commit causes extreme sadness:
> [ 4094.241243] usb 2-5: new high speed USB device using ehci_hcd and 
> address 3
> [ 4095.550452] usb 2-5: ath9k_htc: Transferred FW: ar9271.fw, size: 51312
> [ 4095.816072] ath9k_htc 2-5:1.0: ath9k_htc: HTC initialized with 33 credits
> [ 4159.812888] usb 2-5: USB disconnect, address 3
> [ 4159.929317] ath: Couldn't reset chip
> [ 4159.929321] ath: Unable to initialize hardware; initialization status: -5
> [ 4159.929323] ath: Unable to initialize hardware; initialization status: -5
> [ 4159.929340] Failed to initialize the device
> [ 4160.012603] ath9k_htc: probe of 2-5:1.0 failed with error -22
> [ 4160.012771] usbcore: registered new interface driver ath9k_htc
> [ 4163.595059] usb 2-5: new high speed USB device using ehci_hcd and 
> address 4
> [ 4164.018920] usb 2-5: ath9k_htc: Transferred FW: ar9271.fw, size: 51312
> [ 4164.284420] ath9k_htc 2-5:1.0: ath9k_htc: HTC initialized with 33 credits
> 
> I'm guessing because I need the mentioned firmware update? Where can I 
> get it? Or better yet can you (this is almost laughable considering the 
> ralink thread right now) get it into linux-firmware? Or is the needed 
> firmware update an unstable thing?

The new FW has to be formally/officially tested before it is merged into
linux-firmware.

> Either way I can wait on the firmware-version fix but where can I find 
> the patch that shows fixes the "driver: usb" issue? Your obviously shows 
> properly :-)

http://linuxwireless.org/en/users/Drivers/ath9k_htc

Sujith
