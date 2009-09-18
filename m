Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.211.175]:34388 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496AbZIRSOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 14:14:42 -0400
Received: by ywh5 with SMTP id 5so1510780ywh.4
        for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 11:14:46 -0700 (PDT)
Message-ID: <4AB3CE12.6030002@gmail.com>
Date: Fri, 18 Sep 2009 14:14:42 -0400
From: Paul Sedor <psedor@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: bug build error
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't build the daily (Sep 18) compat-wireless on ubuntu 9.04 with the 
following error.

paul :~/Desktop/compat-wireless-2009-09-18$ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.28-15-generic/build 
M=/home/paul/Desktop/compat-wireless-2009-09-18 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.28-15-generic'
   LD 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/misc/eeprom/built-in.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/misc/eeprom/eeprom_93cx6.o
   LD 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/usb/built-in.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/usb/cdc_ether.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/usb/rndis_host.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/usb/usbnet.o
   LD 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/built-in.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/main.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/regd.o
   LD [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath.o
   LD 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/built-in.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/usb.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/main.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/cmd.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/mac.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/phy.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/led.o
   LD [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ar9170/ar9170usb.o
   LD 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/built-in.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/caps.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/initvals.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/eeprom.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/gpio.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/desc.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/dma.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/qcu.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/pcu.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/phy.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/reset.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/attach.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/base.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/led.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/rfkill.o
   LD [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath5k/ath5k.o
   LD 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/built-in.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/hw.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/eeprom.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/eeprom_def.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/eeprom_4k.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/eeprom_9287.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/mac.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/calib.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/ani.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/phy.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/beacon.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/main.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/recv.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/xmit.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/virtual.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/rc.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/btcoex.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/pci.o
   LD [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/ath/ath9k/ath9k.o
   LD 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/built-in.o
   CC [M] 
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.o
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c: 
In function ‘b43_do_interrupt’:
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c:1888: 
error: ‘IRQ_WAKE_THREAD’ undeclared (first use in this function)
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c:1888: 
error: (Each undeclared identifier is reported only once
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c:1888: 
error: for each function it appears in.)
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c: 
In function ‘b43_request_firmware’:
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c:2218: 
warning: format not a string literal and no format arguments
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c: 
In function ‘b43_wireless_core_start’:
/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.c:3867: 
error: implicit declaration of function ‘request_threaded_irq’
make[4]: *** 
[/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43/main.o] 
Error 1
make[3]: *** 
[/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless/b43] 
Error 2
make[2]: *** 
[/home/paul/Desktop/compat-wireless-2009-09-18/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/paul/Desktop/compat-wireless-2009-09-18] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.28-15-generic'
make: *** [modules] Error 2

Someone suggested I try the older version from Sep 6 and it will build 
successfully.

However, I'd like to keep the latest version.

TIA
