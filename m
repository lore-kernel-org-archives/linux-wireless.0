Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46713 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0HFT6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 15:58:04 -0400
Received: from [71.117.12.23] (pool-71-117-12-23.sttlwa.dsl-w.verizon.net [71.117.12.23])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o76Jw2Gh006135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 6 Aug 2010 12:58:03 -0700
Message-ID: <4C5C694A.7060500@candelatech.com>
Date: Fri, 06 Aug 2010 12:58:02 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wireless-testing won't build
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[greearb@grok2 wireless-testing.p4s]$ make bzImage modules
make -C /home/greearb/git/wireless-testing O=/home/greearb/kernel/2.6/wireless-testing.p4s/. bzImage modules
   Using /home/greearb/git/wireless-testing as source for kernel
   GEN     /home/greearb/kernel/2.6/wireless-testing.p4s/Makefile
   CHK     include/linux/version.h
   CHK     include/generated/utsrelease.h
   CALL    /home/greearb/git/wireless-testing/scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CC [M]  drivers/net/wireless/libertas/cfg.o
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c: In function ‘lbs_scan_worker’:
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:722: error: ‘TASK_NORMAL’ undeclared (first use in this function)
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:722: error: (Each undeclared identifier is reported only once
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:722: error: for each function it appears in.)
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c: In function ‘lbs_cfg_connect’:
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:1267: error: ‘TASK_INTERRUPTIBLE’ undeclared (first use in this function)
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration of function ‘signal_pending’
/home/greearb/git/wireless-testing/drivers/net/wireless/libertas/cfg.c:1267: error: implicit declaration of function ‘schedule_timeout’
make[6]: *** [drivers/net/wireless/libertas/cfg.o] Error 1
make[5]: *** [drivers/net/wireless/libertas] Error 2
make[4]: *** [drivers/net/wireless] Error 2
make[3]: *** [drivers/net] Error 2
make[2]: *** [drivers] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
