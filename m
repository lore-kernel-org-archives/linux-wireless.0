Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:53154 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0FIGsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 02:48:25 -0400
Received: from [10.23.202.43] (unknown [10.23.202.43])
	by smtp.heaven-czfree.net (Postfix) with ESMTP id DA812147681
	for <linux-wireless@vger.kernel.org>; Wed,  9 Jun 2010 08:48:23 +0200 (CEST)
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: linux-wireless@vger.kernel.org
Date: Wed, 09 Jun 2010 08:50:02 +0200
MIME-Version: 1.0
Subject: Compilation problems with Linux-2.6.34 and compat-wireless-2010-06-05
Message-ID: <4C0F399A.21017.1F03DB8@jafojtik.seznam.cz>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dears,

could you fix this compilation problem:

make -C /usr/src/linux-2.6.34 M=/I/USR_SRC/compat-wireless-2010-06-05 modules
make[1]: Entering directory `/I/USR_SRC/linux-2.6.34'
  CC [M]  /I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.o
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c: In function 
'ipw2100_alloc_device':
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:6138: error: 
'struct net_device' has no member named 'wireless_handlers'
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:6144: error: 
'struct net_device' has no member named 'wireless_data'
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c: At top 
level:
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8406: error: 
unknown field 'num_private' specified in initializer
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8406: 
warning: initialization makes pointer from integer without a cast
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8407: error: 
unknown field 'num_private_args' specified in initializer
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8407: 
warning: excess elements in struct initializer
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8407: 
warning: (near initialization for 'ipw2100_wx_handler_def')
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8408: error: 
unknown field 'private' specified in initializer
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8408: 
warning: excess elements in struct initializer
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8408: 
warning: (near initialization for 'ipw2100_wx_handler_def')
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8409: error: 
unknown field 'private_args' specified in initializer
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8409: 
warning: excess elements in struct initializer
/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00/ipw2100.c:8409: 
warning: (near initialization for 'ipw2100_wx_handler_def')
make[4]: *** [/I/USR_SRC/compat-wireless-2010-06-
05/drivers/net/wireless/ipw2x00/ipw2100.o] Error 1
make[3]: *** [/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless/ipw2x00] Error 2
make[2]: *** [/I/USR_SRC/compat-wireless-2010-06-05/drivers/net/wireless] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [_module_/I/USR_SRC/compat-wireless-2010-06-05] Error 2
make[1]: Leaving directory `/I/USR_SRC/linux-2.6.34'
make: *** [modules] Error 2

regards
   Jara
