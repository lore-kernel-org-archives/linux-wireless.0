Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47324 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752314AbYHVLfR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2008 07:35:17 -0400
Message-ID: <48AEA460.2000400@gmx.de> (sfid-20080822_133522_545636_7455DE3C)
Date: Fri, 22 Aug 2008 13:34:56 +0200
From: Benjamin Schulz <Benjamin_Schulz@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: cannot build compat-wireless
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I have currently a 2.6.24 kernel on the distribution gentoo 
(http://www.gentoo.org). Unfortunately, I can't build compat wireless, 
getting the following error:

> r165184 compat-wireless-2008-08-06 # make
> ./scripts/gen-compat-autoconf.sh config.mk > include/linux/compat_autoconf.h
> make -C /lib/modules/2.6.24-gentoo-r8/build M=/compat-wireless-2008-08-06
> modules
> make[1]: Entering directory `/usr/src/linux-2.6.24-gentoo-r8'
>
>   WARNING: Symbol version dump /usr/src/linux-2.6.24-gentoo-r8/Module.symvers
>            is missing; modules will have no dependencies and modversions.
>
>   LD      /compat-wireless-2008-08-06/drivers/misc/built-in.o
>   CC [M]  /compat-wireless-2008-08-06/drivers/misc/eeprom_93cx6.o
> /bin/sh: scripts/genksyms/genksyms: File or directory not found
> make[3]: *** [/compat-wireless-2008-08-06/drivers/misc/eeprom_93cx6.o] Error 1
> make[2]: *** [/compat-wireless-2008-08-06/drivers/misc] Error 2
> make[1]: *** [_module_/compat-wireless-2008-08-06] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.24-gentoo-r8'
> make: *** [modules] Error 2
> r165184 compat-wireless-2008-08-06 #
Other users of the distribution gentoo have the same error, see

> http://bugs.gentoo.org/show_bug.cgi?id=234139#c4
comment 4
> hmm, I can't even get this stupid thing to build with sudo make && sudo make
> install. errors all over the place.
comment 5
> I got it to compile by commenting out some line in the code, but iwl4965
> wouldn't modprobe.  
with best wishes,

Benjamin


