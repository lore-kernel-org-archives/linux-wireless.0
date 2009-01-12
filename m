Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48915 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZALPse (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 10:48:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [b43] opensource firmware
Date: Mon, 12 Jan 2009 16:48:04 +0100
Cc: Lorenzo Nava <navalorenx@gmail.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Gringoli PhD Gringoli <francesco.gringoli@ing.unibs.it>
References: <200901091129.22708.mb@bu3sch.de> <AE7A4FD8-1728-4CE2-8CC7-DCE699C3B6C9@gmail.com> <20090112153949.GC31525@tuxdriver.com>
In-Reply-To: <20090112153949.GC31525@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901121648.05069.mb@bu3sch.de> (sfid-20090112_164838_142641_ECFE08FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 January 2009 16:39:49 John W. Linville wrote:
> On Sat, Jan 10, 2009 at 06:37:43PM +0100, Lorenzo Nava wrote:
> > Hello everybody,
> >
> > today I tried OpenFWWF with kernel 2.6.28 on a Siemens wifi device with 
> > Broadcom 4306 chipset:
> >
> > BCM94306 802.11g (rev 03)
> > PHY: Analog 2, Type 2, Revision 2
> > Radio: Manuf 0x17F, Version 0x2050, Revision 2
> >
> > I did some tests and everything seems to work fine.
> >
> > I remember, once again, that OpenFWWF needs v480 initvals to work  
> > properly, and was tested on 2.6.27-rc5 kernel.
> 
> Any chance on getting a set of initvals packaged with the open source
> firmware?  That would allow distros like Fedora to package this...

Did anybody try with the set of initvals from my git repository?
It includes the major parts. It just misses parts like the default-beacon-template
and stuff. But that's not really needed for now.

-- 
Greetings, Michael.
