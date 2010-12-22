Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout026.mac.com ([17.148.16.101]:50751 "EHLO
	asmtpout026.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0LVLaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 06:30:23 -0500
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp026.mac.com (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep
 26 2008; 64bit)) with ESMTPSA id <0LDT005SWUMH6X60@asmtp026.mac.com> for
 linux-wireless@vger.kernel.org; Wed, 22 Dec 2010 03:30:22 -0800 (PST)
Subject: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
Date: Wed, 22 Dec 2010 15:30:05 +0400
Message-id: <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
To: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
                  I have a quick question. 

I downloaded the http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/compat-wireless-2.6.37-rc6-3.tar.bz2

The information contained in this link mentions: http://linuxwireless.org/en/users/Download/stable/

"You need kernel headers to compile compat-wireless. Ensure /lib/modules/$(uname -r)/build/ exists and points to the location where the kernel headers are installed. If you do not have them, read your distribution's documentation on getting help."

I have Ubuntu 10.04 as host, but I'm using a cross compiler for the OMAP3530 ARM target, and the kernel directory exists in a separate folder. 

How do I tell the build system to use my cross compiled kernel libraries and headers, and not pick up the host /lib/modules kernel headers? 

i.e. how can I cross compile and build compat-wireless for the ARM target on the host machine? 

cd /path/to/compat-wireless-2.6.32-rc5
./scripts/driver-select <driver-name>
make
sudo make install


Best regards,

Elvis Dowson

