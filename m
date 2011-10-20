Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42576 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1JTXC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 19:02:28 -0400
Received: by wyg36 with SMTP id 36so3415687wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 16:02:27 -0700 (PDT)
MIME-Version: 1.0
From: Alan Pater <alan.pater@gmail.com>
Date: Thu, 20 Oct 2011 17:02:07 -0600
Message-ID: <CAN4ACka-egrr=GnBomT0Yc_r_mzS-+v8OE=D0vBoH+jFQJwX8w@mail.gmail.com> (sfid-20111021_010238_175541_DC2FB63D)
Subject: rtl8192cu - fails to maintain connection to some Access Points
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks

Several people over on Ubuntu Launchpad are reporting that this USB WiFi
adaptor has issues connecting to certain access points. In my case, I cannot
connect to a Meraki mesh network, but have no trouble when using my Android
phone as a WiFi Access Point.

The launchpad bugs are:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/852190
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/869530
https://bugs.launchpad.net/ubuntu/+source/linux-backports-modules-3.0.0/+bug/862684

~$ uname -a
Linux crow 2.6.38-11-generic #50-Ubuntu SMP Mon Sep 12 21:18:14 UTC 2011
i686 i686 i386 GNU/Linux
~$ lsusb
Bus 001 Device 004: ID 0bda:8176 Realtek Semiconductor Corp.

Note that I have tried newer kernels, including 3.1.0 without it making a
difference.

Is there some other steps we could be taking to figure out what is going on
here?

gracias,
Alan
