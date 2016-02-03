Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58712 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbcBCXPJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:15:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1aR6dd-0004Ud-3y
	for linux-wireless@vger.kernel.org; Thu, 04 Feb 2016 00:15:05 +0100
Received: from c-98-235-92-116.hsd1.pa.comcast.net ([98.235.92.116])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 00:15:05 +0100
Received: from andrew by c-98-235-92-116.hsd1.pa.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 00:15:05 +0100
To: linux-wireless@vger.kernel.org
From: Andrew Boyce <andrew@idvector.net>
Subject: wilc1000 staging driver initialization failure
Date: Wed, 3 Feb 2016 18:09:18 -0500
Message-ID: <n8u1av$hqv$1@ger.gmane.org> (sfid-20160204_001522_295888_0E080528)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been working to build and test the staging wilc1000-sdio driver and 
have run into a problem.

I've built a kernel from Greg KH's staging-testing branch and loaded it 
onto our device. When I try to bring the interface up, I get the following:

root@test:~# ifconfig wlan0 up
kernel: [ 3510.400000] DBG [wilc_mac_open: 1014]MAC OPEN[cef20000]
kernel: [ 3510.400000] DBG [wilc_init_host_int: 
2835]Host[cef20000][cd0df1c0]
kernel: [ 3510.400000] DBG [wilc_mac_open: 1023]*** re-init ***
kernel: [ 3510.400000] DBG [wlan_init_locks: 803]Initializing Locks ...
kernel: [ 3510.400000] DBG [wilc_wlan_init: 1589]Initializing WILC_Wlan ...
kernel: [ 3510.400000] DBG [wlan_deinit_locks: 829]De-Initializing Locks
SIOCSIFFLAGS: Input/output error
kernel: [ 3512.400000] [Sendconfigpkt]Set Timed out
kernel: [ 3512.400000] DBG [hostIFthread: 2793]THREAD: Exiting HostIfThread

Any ideas?

I understand that this driver is under active development. Hopefully I 
can get some of the bugs resolved.

Thanks!
  --Andrew

P.S. I apologize if this is the wrong forum for this type of bug report.

