Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3854 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXKJAWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 19:22:16 -0500
Date: Fri, 9 Nov 2007 19:21:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Ruggiero <rugg.argos@tiscali.it>, bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Help with wireless on Fedora 8
Message-ID: <20071110002158.GB32472@tuxdriver.com> (sfid-20071110_002219_359771_40B5C377)
References: <000b01c8231a$b78c82a0$0601a8c0@ruggiero> <001001c8231c$04413d60$0601a8c0@ruggiero> <4734E1BC.1060608@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4734E1BC.1060608@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 09, 2007 at 04:39:56PM -0600, Larry Finger wrote:
> I need some Fedora help. This new b43 user is having problems making a connection. He has a b-only
> AP of unspecified make with no encryption. He is using F8 with the default kernel (I think). He has
> done the following:
> 
> Ruggiero wrote:
> > i used "system->adminstration>Network" and i configurated everything from 
> > there...and the clicking on "activate wlan0" for a while my access point 
> > communicate and in the log i see that it's connected... here are outputs:
> > if i use NetworkManager i see it's connecting...but after a while i get the 
> > message "disconnected"
> 
> Tail of dmesg:
> 
> > wlan0: Initial auth_alg=0
> > wlan0: authenticate with AP 00:0c:41:19:2d:c1
> > wlan0: authenticate with AP 00:0c:41:19:2d:c1
> > wlan0: authenticate with AP 00:0c:41:19:2d:c1
> > wlan0: authentication with AP 00:0c:41:19:2d:c1 timed out
> > wlan0: authentication frame received from 00:0c:41:19:2d:c1, but not in
> > authenticate state - ignored
> > wlan0: RX disassociation from 00:0c:41:19:2d:c1 (reason=4)
> 
> All the b43 messages are normal. He sees the AP with a scan, but never authenticates. Any suggestions?

FWIW, the F8 install kernel has wireless bits that are a month or
so old.  You may want to have him try these kernels:

	http://koji.fedoraproject.org/koji/buildinfo?buildID=23734

Those at least have wireless bits that are up-to-date w/ wireless-2.6.

John
-- 
John W. Linville
linville@tuxdriver.com
