Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39348 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0FMQpG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jun 2010 12:45:06 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ONqIy-0004iY-5R
	for linux-wireless@vger.kernel.org; Sun, 13 Jun 2010 18:45:04 +0200
Received: from d86-32-109-21.cust.tele2.at ([86.32.109.21])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 18:45:04 +0200
Received: from ldm by d86-32-109-21.cust.tele2.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jun 2010 18:45:04 +0200
To: linux-wireless@vger.kernel.org
From: Markus Krainz <ldm@gmx.at>
Subject: Re: [rt2800pci] indirect register access failed
Date: Sun, 13 Jun 2010 16:41:14 +0000 (UTC)
Message-ID: <loom.20100613T183556-399@post.gmane.org>
References: <20100611001357.27b316ba@vlado.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Botka <vbotka@...> writes:

> 
> Hallo,
> 
> with the wireless-testing kernel [1] and the ralink [1814:3090] I can
> not load the firmware [2]. Any idea ?
> 
> [1] 2.6.35-rc2-wl-wt-ralink+
> 
> [2]
> Jun 11 00:07:10 calpella kernel: [ 6828.735900] phy0 ->
rt2800pci_load_firmware: Error - PBF system
> register not ready.
> Jun 11 00:07:10 calpella kernel: [ 6828.736466] phy0 ->
rt2x00pci_regbusy_read: Error - Indirect
> register access failed: offset=0x00007010, value=0x55555555
> 
> Thank you,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Using Ubuntu 10.04 distro I upgraded from 2.6.32 to 2.6.34. Now I have the same
issue.

kernel: [ 2190.398394] phy0 -> rt2800pci_load_firmware: Error - PBF system
register not ready.
kernel: [ 2190.401983] phy0 -> rt2x00pci_regbusy_read: Error - Indirect register
access failed: offset=0x00007010, value=0xd53ac0a5

Help is greatly appreciated.

