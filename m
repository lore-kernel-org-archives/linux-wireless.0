Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53982 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaE3AfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 20:35:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WqAmm-0003CO-AZ
	for linux-wireless@vger.kernel.org; Fri, 30 May 2014 02:35:04 +0200
Received: from 89-68-80-14.dynamic.chello.pl ([89.68.80.14])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 02:35:04 +0200
Received: from pitkotko by 89-68-80-14.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 02:35:04 +0200
To: linux-wireless@vger.kernel.org
From: piotr <pitkotko@gmail.com>
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
Date: Fri, 30 May 2014 00:20:04 +0000 (UTC)
Message-ID: <loom.20140530T020912-598@post.gmane.org> (sfid-20140530_023511_912927_4E7440C3)
References: <536F6620.9030001@gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grumbach, Emmanuel <emmanuel.grumbach@...> writes:

> 
> > 
> > My wireless card was working fine for some time, but after reinstallation of
> > computer with Ubuntu, it stopped working and i keep getting this in my
> > dmesg:
> 
> Can you please share with us the kernel versions you had used until now,
and your current version?
> 

Hi,

I have similar problem. My system is Ubuntu 14.04 with kernel 3.13.0-24
installed on a new Toshiba laptop with N2230 wifi card. 
dmesg:
[  614.007461] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
[  614.007748] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
[  614.007790] iwlwifi 0000:01:00.0: Unable to initialize device.
[  614.008318] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  614.015390] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
[  614.059495] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD failed:
FW Error

Is the card broken?

Best,
Piotr


> > 
> > lspci:
> > 0a:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev
> > c4)
> >          Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN
> > 
> > 
> > dmesg:
> > [ 1465.050832] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> > [ 1465.058299] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> > [ 1465.104509] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
> > failed: FW Error
> > [ 1465.104522] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
> > [ 1465.104527] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
> > [ 1465.104818] iwlwifi 0000:0a:00.0: Unable to initialize device.
> > [ 1465.105296] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> > [ 1465.112770] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> > [ 1465.156493] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
> > failed: FW Error
> > [ 1465.156500] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
> > [ 1465.156504] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
> > [ 1465.156784] iwlwifi 0000:0a:00.0: Unable to initialize device.
> > [ 1465.158031] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> > [ 1465.165471] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> > [ 1465.212534] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
> > failed: FW Error
> > [ 1465.212542] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
> > [ 1465.212546] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
> > [ 1465.212825] iwlwifi 0000:0a:00.0: Unable to initialize device.
> > [ 1465.213119] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> > [ 1465.220559] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> > 
> > Does this mean i have issue with driver/kernel or my wifi card is
> > broken? I tried copying latest uucode for 2230 wireless card
> > (http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=
> > get&target=iwlwifi-2030-ucode-18.168.6.1.tgz)
> > into /lib/firmware and reloading kernel module, no success. Still the
> > same issue.
> > 
> > 
> > Best regards,
> > Alen Krmelj
> > 
> > _______________________________________________
> > ilw mailing list
> > ilw@...
> > http://linux.intel.com/mailman/listinfo/ilw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




