Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61380 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab0AGTge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 14:36:34 -0500
MIME-Version: 1.0
Date: Thu, 7 Jan 2010 20:36:31 +0100
Message-ID: <8db1092f1001071136o20ac7e19nb102c7afde8c21e7@mail.gmail.com>
Subject: [2.6.33-rc3] [WMI?] [RFKILL?] [WIRELESS?] hang: BUG: Unable to handle
	kernel NULL pointer dereference at 00000008
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	carlos@strangeworlds.co.uk,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Last known good: 2.6.33-rc2
Affected: 2.6.33-rc3

Description:

1. When wireless button enabled system hangs on:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0038.JPG

2. When disable bluetooth and wireless button, I got a bug:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0039.JPG

3. When reboot I have message:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0040.JPG

Config:
http://unixy.pl/maciek/download/kernel/2.6.33-rc3/config-2.6.33-rc3

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
