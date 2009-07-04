Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:55626 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZGDLwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 07:52:03 -0400
Message-ID: <4A4F3E79.3090802@freenet.de>
Date: Sat, 04 Jul 2009 13:35:21 +0200
From: "Momonosits" <Peter.Hoyland@t-online.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Make error when compiling compat-wireless 2009-07-04
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have Jaunty in English on a Fujitsu Laptop with a D-Link DWA-160 (rev 
A) WLan Stick. This Stick uses the ar9170 Chip Set. The Compat-Wireless 
Drivers support this Chip Set. I wanted to compile the latest 
compat-wireless drivers (compat-wireless-2009-07-04). After issuing the 
make command I received the following errors.

peter@peter-laptop:~/compat-wireless-2009-07-04$ make
./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
make -C /lib/modules/2.6.28-13-generic/build 
M=/home/peter/compat-wireless-2009-07-04 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.28-13-generic'
LD /home/peter/compat-wireless-2009-07-04/drivers/misc/eeprom/built-in.o
CC [M] 
/home/peter/compat-wireless-2009-07-04/drivers/misc/eeprom/eeprom_93cx6.o
In file included from <command-line>:0:
/home/peter/compat-wireless-2009-07-04/include/net/compat.h:123: error: 
redefinition of ‘skb_queue_is_last’
include/linux/skbuff.h:477: error: previous definition of 
‘skb_queue_is_last’ was here
/home/peter/compat-wireless-2009-07-04/include/net/compat.h:137: error: 
redefinition of ‘skb_queue_next’
include/linux/skbuff.h:491: error: previous definition of 
‘skb_queue_next’ was here
make[3]: *** 
[/home/peter/compat-wireless-2009-07-04/drivers/misc/eeprom/eeprom_93cx6.o] 
Error 1
make[2]: *** 
[/home/peter/compat-wireless-2009-07-04/drivers/misc/eeprom] Error 2
make[1]: *** [_module_/home/peter/compat-wireless-2009-07-04] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.28-13-generic'
make: *** [modules] Error 2

My computing powers are not sufficient to resolve these errors, help 
would be appreciated.

Thanks in advance
Peter
