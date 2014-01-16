Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cock.li ([75.102.27.230]:52255 "EHLO cock.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaAPXhf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 18:37:35 -0500
Message-ID: <52D86B09.2040200@cock.li> (sfid-20140117_003738_411647_7C82920A)
Date: Fri, 17 Jan 2014 00:28:09 +0100
From: Athul <breakmy@cock.li>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Building failed
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I had an issue while building the driver. When I ran make it 
returned this:


CC [M] /home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su/eeprom.o
In file included from 
/home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su/r92su.h:51:0,
from /home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su/eeprom.c:34:
/home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su/sta.h:120:26: 
error: ‘IEEE80211_NUM_TIDS’ undeclared here (not in a function)
In file included from 
/home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su/eeprom.c:34:0:
/home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su/r92su.h:229:22: 
error: variably modified ‘tx_tid’ at file scope
make[4]: *** 
[/home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su/eeprom.o] 
Error 1
make[3]: *** 
[_module_/home/athulcb/downloads/rtlfirmware/rtl8192su-master/r92su] Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-3.2.0-4-amd64'
make: *** [all] Error 2


I'm not sure if this is the right place to submit something like this 
but I though it would be worth a try.

Thanks in advance.
