Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vpn.innerrange.com.au ([203.122.143.146]:17787 "EHLO
	remote.innerrange.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750988AbcD0E2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2016 00:28:42 -0400
From: Craig McQueen <craig.mcqueen@innerrange.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 27 Apr 2016 14:28:39 +1000
Subject: RE: rt2800 and BeagleBone Black kernel panic when connecting to
 access point
Message-ID: <5500469A22567C4BAF673A6E86AFA3A4022D20C813CC@IR-CENTRAL.corp.innerrange.com> (sfid-20160427_062845_211639_5026DEFE)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I previously wrote:
> 
> I have a D-Link DWA-140 USB Wi-Fi device which is rt2800 based (5392
> chipset). I've been testing it on a BeagleBone Black running an Ubuntu 16.04
> image (4.4.6 kernel).
> 
> 1) Install Ubuntu 16.04 on a BeagleBone Black.
> 2) Add lines to /etc/network/interfaces for the device to connect to a WPA2
> access point.
> 3) Plug the rt2800 USB Wi-Fi device into the BeagleBone Black.
> 
> Apparently when it tries to connect to the access point, I get a kernel panic. If
> I don't configure it (step 2 above) then the kernel panic doesn't happen.
> 
> I've tested this with two access points: my Android phone acting as a
> hotspot, and a cheap TP-Link TD-W8968.

I should add an extra interesting detail: if I plug the Wi-Fi device into a USB hub, instead of directly into the BeagleBone Black, then the kernel panic doesn't happen, and I'm able to use it successfully (although with other problems which I'll report in further e-mails).

-- 
Craig McQueen


