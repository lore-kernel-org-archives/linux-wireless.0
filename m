Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mdfmta009.mxout.tbr.inty.net ([91.221.168.50]:46589 "EHLO
	smtp.demon.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751420AbaGJJfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2014 05:35:09 -0400
Message-ID: <53BE5E49.6040603@dpets.co.uk> (sfid-20140710_113515_557420_CFFCF3A7)
Date: Thu, 10 Jul 2014 10:35:05 +0100
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rtl8192se static driver in 3.14 kernel not working
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that we have a different problem with this driver from others I 
mentioned in a recent thread.

I have compiled a kernel from the 3.14.7 from linux-source-3.14 from 
Debian for use on a Samsung N120 netbook.

Included in the .config are:

CONFIG_WLAN=y
CONFIG_RTL_CARDS=y
CONFIG_RTL8192SE=y

There are no LKMs or initramfs.

The wireless does not work at all.  dmesg shows the pci device but there 
is no sign of the wireless driver.

With a 2.6 kernel set up similarly the wireless works.

