Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:38315 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752840AbZIZC5U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 22:57:20 -0400
From: Malte Gell <malte.gell@gmx.de>
To: linux-wireless@vger.kernel.org
Subject: cannot compile compate-wirless snapshots
Date: Sat, 26 Sep 2009 04:57:20 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909260457.21103.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

actually I can build the stable compat-wirless-2.6.30.ta.bz2 just fine.

But I get make errors, when I try to build the daily snapshot, see below. I 
use openSUSE on a 2.6.27 kernel.

Thanx, Malte


2[malte_gell@linux-61r3]12535 04:50~/download/src/wifi/compat-
wireless-2009-09-25> make
make -C /lib/modules/2.6.27.29-0.1-k7/build 
M=/home/malte_gell/download/src/wifi/compat-wireless-2009-09-25 modules
make[1]: Entering directory `/usr/src/linux-2.6.27.29-0.1'
  CC [M]  /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless/ath/main.o
In file included from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat.h:19,
                 from <command-line>:0:
/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:152: error: redefinition of 
'struct tracepoint'
In file included from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat.h:19,
                 from <command-line>:0:
/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:182:1: warning: "DEFINE_TRACE" 
redefined
In file included from include/linux/module.h:19,
                 from include/linux/textsearch.h:7,
                 from include/linux/skbuff.h:26,
                 from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:10,
                 from /home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat.h:19,
                 from <command-line>:0:
include/linux/tracepoint.h:86:1: warning: this is the location of the previous 
definition
/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/include/net/compat-2.6.28.h:186: error: redefinition of 
'tracepoint_update_probe_range'
include/linux/tracepoint.h:100: error: previous definition of 
'tracepoint_update_probe_range' was here
make[4]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless/ath/main.o] Error 1
make[3]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless/ath] Error 2
make[2]: *** [/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/malte_gell/download/src/wifi/compat-
wireless-2009-09-25] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.27.29-0.1'
make: *** [modules] Error 2
