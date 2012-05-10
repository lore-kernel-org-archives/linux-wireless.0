Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swm.pp.se ([212.247.200.143]:33957 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab2EJEpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 00:45:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by uplift.swm.pp.se (Postfix) with ESMTP id E6DD09A
	for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 06:39:53 +0200 (CEST)
Date: Thu, 10 May 2012 06:39:53 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: linux-wireless@vger.kernel.org
Subject: iwlagn/iwlwifi kernel 3.2 related crashes
Message-ID: <alpine.DEB.2.00.1205100633040.16144@uplift.swm.pp.se> (sfid-20120510_064552_004914_43DC7F61)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Ever since I upgraded my Thinkpad X200 with Intel 5300 wifi to Ubuntu 
12.04 with its 3.2 kernel, I've seen iwlagn related crashes every couple 
of days. With 11.10 (kernel 3.0) I didn't have this problem.

I have taken two pictures of the screen when this happened (separate 
occasions):

<http://swm.pp.se/IMG_20120506_200427.jpg>

<http://swm.pp.se/IMG_20120510_112645.jpg>

03:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
 	Subsystem: Intel Corporation Device 1011
 	Physical Slot: 1
 	Flags: bus master, fast devsel, latency 0, IRQ 48
 	Memory at f2a00000 (64-bit, non-prefetchable) [size=8K]
 	Capabilities: [c8] Power Management version 3
 	Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
 	Capabilities: [e0] Express Endpoint, MSI 00
 	Capabilities: [100] Advanced Error Reporting
 	Capabilities: [140] Device Serial Number 00-21-6a-ff-ff-03-8c-26
 	Kernel driver in use: iwlwifi
 	Kernel modules: iwlwifi

$ uname -a
Linux swm-laptop 3.2.0-24-generic-pae #37-Ubuntu SMP Wed Apr 25 10:47:59 
UTC 2012 i686 i686 i386 GNU/Linux

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
