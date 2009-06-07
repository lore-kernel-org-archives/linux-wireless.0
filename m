Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53034 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZFGUox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 16:44:53 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MDPEa-0004CF-OW
	for linux-wireless@vger.kernel.org; Sun, 07 Jun 2009 20:44:52 +0000
Received: from p5086D5AB.dip.t-dialin.net ([80.134.213.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 20:44:52 +0000
Received: from sparcoular by p5086D5AB.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jun 2009 20:44:52 +0000
To: linux-wireless@vger.kernel.org
From: Markus <sparcoular@t-online.de>
Subject: Re: bcm43xx 5.10.38.35 firmware
Date: Sun, 7 Jun 2009 20:44:39 +0000 (UTC)
Message-ID: <loom.20090607T201048-919@post.gmane.org>
References: <loom.20090607T124008-575@post.gmane.org> <4A2BBD98.4040708@lwfinger.net> <loom.20090607T140512-723@post.gmane.org> <4A2BEAFF.7090109@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> As it says in the wiki, an interface with the 0x4328 ID is not
> supported. You need to use the Broadcom wl driver, which is
> proprietary. I suppose that this was the "Restricted Driver" from
> Ubuntu. Your other option would be to get the driver from Broadcom and
> build it on your system.
> 
> We are in the process of doing the reverse engineering on the N-PHY
> devices, but it does not have high priority at the moment.
> 
> Larry
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


Finally got it working again. 

A patched sta- version from the Ubuntu repository did it.

That one directly from Broadcom won't compile without

some code-change.

Thx and keep on Hacking

Markus


