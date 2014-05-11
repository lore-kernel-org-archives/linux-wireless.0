Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51058 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaEKL7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 May 2014 07:59:32 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so3815484eek.21
        for <linux-wireless@vger.kernel.org>; Sun, 11 May 2014 04:59:31 -0700 (PDT)
Message-ID: <536F6620.9030001@gmail.com> (sfid-20140511_140027_119821_C261D9A2)
Date: Sun, 11 May 2014 13:59:28 +0200
From: Alen Krmelj <krmelj.alen@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: ilw@linux.intel.com
Subject: Wireless Centrino 2230-N issues
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My wireless card was working fine for some time, but after 
reinstallation of computer with Ubuntu, it stopped working and i keep 
getting this in my dmesg:

lspci:
0a:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 
(rev c4)
         Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN


dmesg:
[ 1465.050832] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
[ 1465.058299] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
[ 1465.104509] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD 
failed: FW Error
[ 1465.104522] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
[ 1465.104527] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
[ 1465.104818] iwlwifi 0000:0a:00.0: Unable to initialize device.
[ 1465.105296] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
[ 1465.112770] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
[ 1465.156493] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD 
failed: FW Error
[ 1465.156500] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
[ 1465.156504] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
[ 1465.156784] iwlwifi 0000:0a:00.0: Unable to initialize device.
[ 1465.158031] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
[ 1465.165471] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
[ 1465.212534] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD 
failed: FW Error
[ 1465.212542] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
[ 1465.212546] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
[ 1465.212825] iwlwifi 0000:0a:00.0: Unable to initialize device.
[ 1465.213119] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
[ 1465.220559] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0

Does this mean i have issue with driver/kernel or my wifi card is 
broken? I tried copying latest uucode for 2230 wireless card 
(http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-2030-ucode-18.168.6.1.tgz) 
into /lib/firmware and reloading kernel module, no success. Still the 
same issue.


Best regards,
Alen Krmelj
