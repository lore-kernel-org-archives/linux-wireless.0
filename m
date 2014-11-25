Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-tmp.wmich.edu ([141.218.1.43]:11632 "EHLO mx-tmp.wmich.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaKYQ0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 11:26:17 -0500
Received: from avs01.service.private (avs01.service.private [172.30.31.161])
 by mta02.service.private
 (Sun Java System Messaging Server 6.1 HotFix 0.13 (built Jun  8 2005))
 with ESMTP id <0NFL00MS5S39Z830@mta02.service.private> for
 linux-wireless@vger.kernel.org; Tue, 25 Nov 2014 11:21:15 -0500 (EST)
Date: Tue, 25 Nov 2014 11:21:02 -0500 (EST)
From: Mohammad Ali Ma Abu Shattal <mohammad.a.shattal@wmich.edu>
Subject: Setting WLAN RF Sensitivity value
In-reply-to: <2109154365.18865892.1416932147808.JavaMail.root@wmich.edu>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Message-id: <1013439490.18867944.1416932462547.JavaMail.root@wmich.edu> (sfid-20141125_172623_933801_54803406)
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Sir/Madam,

I'm working on a project in which we need to set and get RF sensitivity of WLAN device. I tried to set other settings such as operation mode, txpower and frequency using Linux commands : "ioctl" and "iwconfig" and it works fine. Manufacturer of my device is Broadcom. It seems that either the hardware or the driver doesn't support setting and getting sensitivity. I need to know if there exists a device and/or device driver that support this feature. details of my current hardware and device driver are posted in the askubuntu question:
http://askubuntu.com/questions/553286/wlan-sensitivity-setting-is-not-supported
kindly send me your recommendation for such device or device driver.

best regards,
Mohammad
---------------------------- 
Mohammad Abu Shattal
Ph.D Student
Department of Electrical & Computer Engineering
Western Michigan University
Kalamazoo, MI 49008
