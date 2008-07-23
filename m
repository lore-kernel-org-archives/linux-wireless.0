Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.globalproof.net ([194.146.153.25]:50779 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbYGWWRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 18:17:34 -0400
From: denys@visp.net.lb
To: linux-wireless@vger.kernel.org
Subject: 2.6.26-git10 compile error, iwl-led.c
Date: Thu, 24 Jul 2008 00:49:28 +0300
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200807240049.29021.denys@visp.net.lb> (sfid-20080724_001745_718029_7AEE4C0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sunfire-1 linux-2.6.26 # sunfire-1 globalosii # cp globalfs1 globalfs
sunfire-1 linux-2.6.26 # make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
dnsdomainname: Unknown host
  GEN     usr/initramfs_data.cpio.gz
  AS      usr/initramfs_data.o
  LD      usr/built-in.o
  LD [M]  drivers/net/wireless/rtl8187.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-led.o
drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
make[4]: *** [drivers/net/wireless/iwlwifi/iwl-led.o] Error 1
make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
