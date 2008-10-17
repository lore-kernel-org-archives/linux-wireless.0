Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:62707 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbYJQMzV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Oct 2008 08:55:21 -0400
Subject: 10-17-2008 Build issues - Intel 3945abg - Ubuntu Intrepid
From: Myk Robinson <myk.robinson@kingdomcomputer.info>
Reply-To: myk.robinson@kingdomcomputer.info
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Fri, 17 Oct 2008 07:55:17 -0500
Message-Id: <1224248117.28593.3.camel@mobileOne> (sfid-20081017_145526_469103_9FAB9135)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello-

Used your driver package in Ubuntu Hardy with no trouble at all. Testing
the Intrepid beta now. Before today, using the compat-wireless driver
for kernel 2.6.27, networkmanager showed all devices grayed out and
iwlist scan would not work. Today's driver release has allowed me to
connect, but still drops the connection with intel 2945abg. Also, it
causes the touchpad to lose sync when the connection is dropped.

Here is a pastebin containing some dmesg info that might be helpful.

http://pastebin.com/f286ee42c

Thanks,

-- 
--
Myk Robinson
Computer Support Specialist
Kingdom Computer Solutions
http://www.kingdomcomputer.info
myk.robinson@kingdomcomputer.info
(731) 616.5030

