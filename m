Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:32800 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZJRIeI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2009 04:34:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MzRDP-0000Go-C4
	for linux-wireless@vger.kernel.org; Sun, 18 Oct 2009 10:34:11 +0200
Received: from 119.152.101.234 ([119.152.101.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2009 10:34:11 +0200
Received: from Azhar.iq by 119.152.101.234 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2009 10:34:11 +0200
To: linux-wireless@vger.kernel.org
From: Azhar <Azhar.iq@gmail.com>
Subject: Re: TL-WN721N
Date: Sun, 18 Oct 2009 08:33:46 +0000 (UTC)
Message-ID: <loom.20091018T103209-571@post.gmane.org>
References: <loom.20091015T161901-805@post.gmane.org> <20091015151058.GC2809@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville <linville@...> writes:

> 
> On Thu, Oct 15, 2009 at 02:20:52PM +0000, Azhar wrote:
> > Hi all,
> > 
> > I am looking for drivers of TL-WN721N (for linux)...i have been going through
> > pages aand pages of documentation....but every other link seems to route
> > here...i would really appreciate if you could guide me
> > 
> > Thanks
> > 
> > Azhar
> 
> Is it PCI?  USB?  The output of lspci or lsusb would be helpful
> to know.  Of course, in most cases you distribution would have the
> driver auto-loaded for you if it was supported at all...
> 
> John

ndiswrapper -l

WARNING: All config files need .conf: /etc/modprobe.d/ndiswrapper, it will be
ignored in a future release.
WARNING: All config files need .conf: /etc/modprobe.d/blacklist, it will be
ignored in a future release.
netathur : driver installed
device (0CF3:9271) present


lsusb

Bus 001 Device 003: ID 0cf3:9271 Atheros Communications, Inc.
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub





