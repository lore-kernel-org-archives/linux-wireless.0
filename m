Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757663AbYCEXZX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 18:25:23 -0500
Message-ID: <47CF2BE1.2020305@gmx.at> (sfid-20080305_232528_641270_F8C4B746)
Date: Thu, 06 Mar 2008 00:25:21 +0100
From: Franz Apeltauer <franz.apeltauer@gmx.at>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
References: <47CB3B5E.4020701@gmx.at>	 <1204504331.3917.31.camel@johannes.berg>	 <20080303035222.GP28995@ruslug.rutgers.edu>  <47CF28F2.6050509@gmx.at>	 (sfid-20080305_231328_405485_4CF10539) <1204758941.25502.93.camel@johannes.berg>
In-Reply-To: <1204758941.25502.93.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg schrieb:
>> a) Test on a PC with a Broadcom 4306 rev 03:
>> - Downloaded and installed the firmware.
>> - The module b43legacy loads without errors, but nothing else happens.
>>    ifconfig doesn't show any new interface, like eth0 or wlan0.
> 
> Well, yeah, you need b43...
> 
> johannes

I'm sorry, almost the same result:
# rmmod b43legacy
# modprobe b43
=> messages: Mar  6 00:18:36 af-nb-3 kernel: [14393.692000] Broadcom 
43xx driver loaded [ Features: PML, Firmware-ID: FW13 ]
=> dmesg: [14393.692000] Broadcom 43xx driver loaded [ Features: PML, 
Firmware-ID: FW13 ]

Again: No new interfaces.

Franz
