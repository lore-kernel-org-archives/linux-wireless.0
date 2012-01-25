Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43591 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AYSDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 13:03:19 -0500
Received: by iacb35 with SMTP id b35so7076826iac.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Jan 2012 10:03:19 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 25 Jan 2012 19:03:19 +0100
Message-ID: <CAD2CPUEu2ha6TeYrQ4WUdXU0-hdSAAJZR5PGWagSguE1DtBSfQ@mail.gmail.com> (sfid-20120125_190322_674431_1ECC0AEB)
Subject: [bcm4329] brcmfmac on kernel 2.6.35 (Andorid)
From: Renzo Navas <renzoefra@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good evening to everyone,

This is my first email here (so I am a bit 'afraid'), I am brand new
to kernel development,

I will try to go to the point and then add some more background.
My principal question -any answer would help-:

  * Is it factible to use the brcmfmac driver on a kernel 2.6.35,
specifically one made for Android (CyanogenMod 7) kernel?



That's my only question. Now I will try to give more information that
my help to understand what I want:


For the next 4 following months I will be modifying the bcm4329 driver
for a Nexus S cellphone (aliases: samsung Ccespo, herring),
particularly the scanning algorithm.

So far all the android kernel versions for android use a deprecated
driver called the "bcm4329" -which uses WirelessExtensions-:

* https://github.com/CyanogenMod/cm-kernel/tree/android-msm-2.6.37/drivers/net/wireless/bcm4329
* https://github.com/CyanogenMod/samsung-kernel-crespo/tree/android-samsung-2.6.35/drivers/net/wireless/bcm4329

So as I will spend the next 4 months investigating/experimenting with
a bcm4329 driver,
I think that whatever results -or not- that I will come across after
this time (it's academic research, and will end up in a thesis about
scanning algorithms), It will be better-worthy for all the community,
if that results are achieved on the brcmfmac driver and not on this
'bcm4329' old-only-android driver.

I have found only these attemps of some people trying to do this:

   * On this same list: thread "brcmfmac + compat wireless + 2.6.35"
http://thread.gmane.org/gmane.linux.kernel.wireless.general/81301/
   * On "freesmartphone" proyect:
http://wiki.freesmartphone.org/index.php/HardwareComparison column
"Nexus S" row "Wifi":
                        "bcm4329: * we must make brcmfmac work(trough
making a dummy IRQ handler for function 2 of the sdio chip) * Require
a non-free firmware"

On both testimonies seems to conclude that porting "brcmfmac" for
android has not been successful.

Thank you very much for your attention, and I'm glad to have
discovered this nice community.

Greetings,

Renzo Navas
