Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kso.tls-tautenburg.de ([194.94.209.8]:53953 "EHLO
	kso.tls-tautenburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZFCLGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 07:06:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 588402E8
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2009 13:04:07 +0200 (CEST)
Received: from kso.tls-tautenburg.de ([127.0.0.1])
 by localhost (kso [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 10197-01 for <linux-wireless@vger.kernel.org>;
 Wed,  3 Jun 2009 13:04:00 +0200 (CEST)
Received: from [192.168.2.220] (unknown [200.72.135.40])
	by kso.tls-tautenburg.de (Postfix) with ESMTP id 2D648232
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2009 13:03:59 +0200 (CEST)
Message-ID: <4A26593B.6050704@tls-tautenburg.de>
Date: Wed, 03 Jun 2009 13:06:35 +0200
From: Bringfried Stecklum <stecklum@tls-tautenburg.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compile error: compat-wireless-2009-06-03
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to compile the latest compat-wireless package on an Ubuntu 8.10
64bit system running linux kernel 2.6.27-12 I get the following error

stecklum@extragalactix:~/System/src/compat-wireless-2009-06-03$ make
make -C /lib/modules/2.6.27-12-mygeneric/build 
M=/home/stecklum/System/src/compat-wireless-2009-06-03 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
   CC [M] 
/home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k/hw.o
In file included from 
/home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k/hw.c:20:
/home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k/ath9k.h:469: 
error: field ‘ops’ has incomplete type
make[5]: *** 
[/home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k/hw.o] 
Error 1
make[4]: *** 
[/home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath/ath9k] 
Error 2
make[3]: *** 
[/home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless/ath] 
Error 2
make[2]: *** 
[/home/stecklum/System/src/compat-wireless-2009-06-03/drivers/net/wireless] Error 2
make[1]: *** [_module_/home/stecklum/System/src/compat-wireless-2009-06-03] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneric'
make: *** [modules] Error 2


Regards,

	Bringfried


