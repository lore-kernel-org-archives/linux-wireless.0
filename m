Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38703 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab1DJR3w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 13:29:52 -0400
Received: by wya21 with SMTP id 21so4228058wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 10:29:51 -0700 (PDT)
Message-ID: <4DA1E90A.5070902@gmail.com>
Date: Sun, 10 Apr 2011 19:29:46 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: Firmware files for Ralink RT28x0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Hutchings wrote:

> I notice that rt2800{pci,usb} each specify only one firmware image,
> regardless of the controller version.
> 
> This is inconsistent with rt28{6,7}0sta and with the firmware images in
> linux-firmware.
> 
> If you think that a single image per bus type can cover all controllers,
> please identify those firmware images, test them on each hardware
> generation, and get them into linux-firmware.

querida:/datos/kernel/linux-2.6/drivers/net/wireless/rt2x00 $ grep "\.bin" *
rt2800pci.h:#define FIRMWARE_RT2860			"rt2860.bin"
rt2800usb.h:#define FIRMWARE_RT2870			"rt2870.bin"
rt61pci.h:#define FIRMWARE_RT2561			"rt2561.bin"
rt61pci.h:#define FIRMWARE_RT2561s			"rt2561s.bin"
rt61pci.h:#define FIRMWARE_RT2661			"rt2661.bin"
rt73usb.h:#define FIRMWARE_RT2571			"rt73.bin"

rt3070.bin rt3071.bin rt3090.bin should be deleted from linux-firmware.
They were only need by staging drivers.

-- 
«Allá muevan feroz guerra, ciegos reyes por un palmo más de tierra;
que yo aquí tengo por mío cuanto abarca el mar bravío, a quien nadie
impuso leyes. Y no hay playa, sea cualquiera, ni bandera de esplendor,
que no sienta mi derecho y dé pecho a mi valor.»
