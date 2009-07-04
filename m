Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s32.blu0.hotmail.com ([65.55.111.107]:3636 "EHLO
	blu0-omc2-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbZGDCo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 22:44:29 -0400
Message-ID: <BLU0-SMTP33F4230D49592F7AC596A9C22D0@phx.gbl>
Date: Fri, 03 Jul 2009 21:44:27 -0500
From: Brett Ussher <breusshe@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 'skb_queue_is_last' and 'skb_queue_next' errors during make (2.6.31-rc1)
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I keep getting an error when I try to make the 2.6.31-rc1 compat-wireless:

=====================================================================

compat-wireless-2.6.31-rc1 $ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.28-13-generic/build 
M=/home/brett/Desktop/compat-wireless-2.6.31-rc1 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.28-13-generic'
LD 
/home/brett/Desktop/compat-wireless-2.6.31-rc1/drivers/misc/eeprom/built-in.o
CC [M] 
/home/brett/Desktop/compat-wireless-2.6.31-rc1/drivers/misc/eeprom/eeprom_93cx6.o
In file included from <command-line>:0:
/home/brett/Desktop/compat-wireless-2.6.31-rc1/include/net/compat.h:123: 
error: redefinition of ‘skb_queue_is_last’
include/linux/skbuff.h:477: error: previous definition of 
‘skb_queue_is_last’ was here
/home/brett/Desktop/compat-wireless-2.6.31-rc1/include/net/compat.h:137: 
error: redefinition of ‘skb_queue_next’
include/linux/skbuff.h:491: error: previous definition of 
‘skb_queue_next’ was here
make[3]: *** 
[/home/brett/Desktop/compat-wireless-2.6.31-rc1/drivers/misc/eeprom/eeprom_93cx6.o] 
Error 1
make[2]: *** 
[/home/brett/Desktop/compat-wireless-2.6.31-rc1/drivers/misc/eeprom] Error 2
make[1]: *** [_module_/home/brett/Desktop/compat-wireless-2.6.31-rc1] 
Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.28-13-generic'
make: *** [modules] Error 2

=====================================================================

I'm using Ubuntu 9.04 with kernel 2.6.28-13-generic. Is there a way to 
stop this error?

-- 
Brett D. Ussher

