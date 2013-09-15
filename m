Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([2.119.245.41]:50089 "EHLO
	mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IOUlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Sep 2013 16:41:32 -0400
Message-ID: <523619A8.7000702@linuxsystems.it> (sfid-20130915_224145_496586_8AF6A7F0)
Date: Sun, 15 Sep 2013 22:33:44 +0200
From: =?ISO-8859-15?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ilw@linux.intel.com
Subject: iwlwifi (5100 AGN) AP mode (experimental?)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I read[1] iwlwifi should have experimental support for AP mode.

Unfortunately ap mode isn't listed:

laptop ~ # iw list | grep -i ap
                 Capabilities: 0x1072
                 Capabilities: 0x1072
                  * start_ap
                  * set_noack_map
                  * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 
0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                  * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 
0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                  * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                  * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
         HT Capability overrides:

Do I need a special firmware/kernel version? I'm using 3.11.0 and 
linux-firmware-20130728.

Thanks,
Niccolò

[1]http://wireless.kernel.org/en/users/Drivers/iwlwifi
-- 
http://www.linuxsystems.it
