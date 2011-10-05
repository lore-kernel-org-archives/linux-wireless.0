Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63803 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900Ab1JEW5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:57:14 -0400
Received: by iakk32 with SMTP id k32so2286529iak.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 15:57:14 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Oct 2011 15:57:13 -0700
Message-ID: <CAFHVRfc1N8YNCmxMwsk1_UCZFQuOMNJE-9y31dnfcwrDsk36wA@mail.gmail.com> (sfid-20111006_005717_594989_29B8BC5E)
Subject: Cannot make ath9k driver
From: Panu Avakul <avakulpa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I got the compat-wireless-2011-09-27 and was trying to make the
ath9k driver.
I did the
./scripts/driver-select ath9k
sudo make unload
sudo make

However, it give me this error

make -C /lib/modules/2.6.38-11-generic-pae/build
M=/home/radius0014/compat-wireless-2011-09-27 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.38-11-generic-pae'
  CC [M]  /home/radius0014/compat-wireless-2011-09-27/drivers/net/wireless/ath/debug.o
/home/radius0014/compat-wireless-2011-09-27/drivers/net/wireless/ath/debug.c:19:13:
error: redefinition of ‘ath_opmode_to_string’
/home/radius0014/compat-wireless-2011-09-27/drivers/net/wireless/ath/ath.h:280:27:
note: previous definition of ‘ath_opmode_to_string’ was here
make[4]: *** [/home/radius0014/compat-wireless-2011-09-27/drivers/net/wireless/ath/debug.o]
Error 1
make[3]: *** [/home/radius0014/compat-wireless-2011-09-27/drivers/net/wireless/ath]
Error 2
make[2]: *** [/home/radius0014/compat-wireless-2011-09-27/drivers/net/wireless]
Error 2
make[1]: *** [_module_/home/radius0014/compat-wireless-2011-09-27] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.38-11-generic-pae'
make: *** [modules] Error 2

Does anyone have similar problem or know someway to fix this?
I used to got it to compiled a while ago and did not work with it until now.
I also tried different version and they all giving me similar error.

Thank you very much,
Best Regards,
Panu
