Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wsip-68-15-54-132.ri.ri.cox.net ([68.15.54.132]:2654 "EHLO
	zernable.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbYETAOa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 20:14:30 -0400
Subject: Troubleshooting slow wireless
From: lwireless <lwireless@zernable.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 19 May 2008 20:07:48 -0400
Message-Id: <1211242068.14840.21.camel@emit.zernable.net> (sfid-20080520_021434_539688_7B64048F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been trying to diagnose an issue I'm having with my wireless
connection going slow. If I reboot, or reload my NIC modules, I can get
a speed of around 2.2 - 2.5MB/s. However, after a period of time my
speed will drop to ~150KB/s. Once it does that, the only way to increase
it again is to reload the module. The amount of time it works properly
before it drops in speed doesn't seem to be consistent. It can be 10
minutes or 10 hours.

Kernel 2.6.24
iwl3945 drivers with an Intel 3945ABG NIC in my Lenovo T61
I've experienced the same issues with the drivers built with the 2.6.24
kernel, and the updated compat-wireless drivers from 5/7 & 5/18. 
My signal strength or quality doesn't change between when it's fast or
not.
I'm always connected to an NFS share on my server if that makes any
difference, but I'm testing my speeds with SCP primarily.

Any advice given would be much appreciated. If you need further info
from me, please ask. I'd love to get this solved as it's quite annoying.

Thanks.

