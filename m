Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55236 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbXFMHZm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 03:25:42 -0400
Received: from math.ut.ee (math.ut.ee [193.40.36.2])
	by smtp2.it.da.ut.ee (Postfix) with ESMTP id 58BA84C03951
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2007 10:25:40 +0300 (EEST)
Received: from localhost (localhost [127.0.0.1])
	by math.ut.ee (Postfix) with ESMTP id 505796ADEB
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2007 10:25:40 +0300 (EEST)
Date: Wed, 13 Jun 2007 10:25:40 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: linux-wireless@vger.kernel.org
Subject: libertas warnings in upstream
Message-ID: <Pine.SOC.4.64.0706131022450.12888@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tried to test-compile libertas on a 64-bit platform. Are these better in 
2.6.23 material?

  CC [M]  drivers/net/wireless/libertas/cmd.o
drivers/net/wireless/libertas/cmd.c: In function 'wlan_cmd_802_11_set_wep':
drivers/net/wireless/libertas/cmd.c:189: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/libertas/cmd.c:195: warning: large integer implicitly truncated to unsigned type
  CC [M]  drivers/net/wireless/libertas/cmdresp.o
  CC [M]  drivers/net/wireless/libertas/scan.o
drivers/net/wireless/libertas/scan.c: In function 'wlan_scan_process_results':
drivers/net/wireless/libertas/scan.c:235: warning: unused variable 'i'
  CC [M]  drivers/net/wireless/libertas/join.o
  CC [M]  drivers/net/wireless/libertas/11d.o
  CC [M]  drivers/net/wireless/libertas/ioctl.o
  CC [M]  drivers/net/wireless/libertas/debugfs.o
drivers/net/wireless/libertas/debugfs.c: In function 'libertas_getscantable':
drivers/net/wireless/libertas/debugfs.c:85: warning: format '%08llx' expects type 'long long unsigned int', but argument 4 has type 'u64'
drivers/net/wireless/libertas/debugfs.c:85: warning: format '%08llx' expects type 'long long unsigned int', but argument 4 has type 'u64'

-- 
Meelis Roos (mroos@linux.ee)
