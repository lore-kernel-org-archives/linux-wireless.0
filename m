Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crow.informatik.tu-cottbus.de ([141.43.3.8]:60796 "EHLO
	crow.informatik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbaIYQy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2014 12:54:26 -0400
Received: from kakadu.Informatik.TU-Cottbus.DE (kakadu.informatik.tu-cottbus.de [141.43.3.3])
	by crow.informatik.tu-cottbus.de (8.13.8/8.13.8) with ESMTP id s8PGsPJW029004
	for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 18:54:25 +0200
Received: from [141.43.202.202] (usedom.informatik.tu-cottbus.de [141.43.202.202])
	by kakadu.Informatik.TU-Cottbus.DE (8.13.8+Sun/8.13.8) with ESMTP id s8PGsOwB016359
	for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 18:54:25 +0200 (CEST)
Message-ID: <542448C0.9040505@Informatik.TU-Cottbus.DE> (sfid-20140925_185430_481738_2DC6EA5E)
Date: Thu, 25 Sep 2014 18:54:24 +0200
From: Pink <pink@Informatik.TU-Cottbus.DE>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Question about debugging mac80211 without printk
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

actually if have the following problem, if have a lot of debug messages 
using printk inside the mac layer but if there is a
critical bug in the source code of the mac80211 module
the system goes into kernel panic state during execution. Unfortunately 
so far i now, it isn't possible
after a system restart to identify the rough position of the bug looking 
for the debug msg's written before the bug has occured in
dmesg or syslog because the messages were not saved in follow of the crash.

Now i thought user mode linux (uml) is maybe a potential solution to 
identify the bug, if the kernel running the mac layer
is executed as virtual machine in uml. But i didn't found any kind of 
description how to forward the physical wireless card except using 
TAP/TUN device to the vm so
that the kernel inside the vm can run its mac layer directly on the card.

Now my question what tools are you use for the development and testing 
of the ath wireless driver
as well as the complete wireless stack including mac80211. Is it user 
mode linux or something else?
If user mode linux is used, is there any howto available to forward the 
atheros card to the vm.

Thank Mario

