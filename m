Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56019 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYLOSBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 13:01:04 -0500
Subject: Re: Fuijtsu Lifebook RFKILL support
From: Dan Williams <dcbw@redhat.com>
To: tony@linx.net
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Len Brown <lenb@kernel.org>, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-acpi@vger.kernel.org, jwoithe@physics.adelaide.edu.au,
	Peter Gruber <nokos@gmx.net>, linux-wireless@vger.kernel.org
In-Reply-To: <1229361241.13400.1.camel@localhost>
References: <1228957506.4045.11.camel@localhost>
	 <20081211165247.GA4844@khazad-dum.debian.net>
	 <1229016827.6446.6.camel@localhost>
	 <20081211194734.GA18132@khazad-dum.debian.net>
	 <1229046602.4030.13.camel@localhost>
	 <20081212195331.GA12679@khazad-dum.debian.net>
	 <alpine.LFD.2.00.0812121532580.4064@localhost.localdomain>
	 <1229172465.4010.11.camel@localhost>
	 <20081213132857.GA11428@khazad-dum.debian.net>
	 <1229274343.6775.15.camel@localhost.localdomain>
	 <20081215115336.GD17648@khazad-dum.debian.net>
	 <1229354348.12163.20.camel@localhost.localdomain>
	 <1229361241.13400.1.camel@localhost>
Content-Type: text/plain
Date: Mon, 15 Dec 2008 12:59:44 -0500
Message-Id: <1229363984.12163.114.camel@localhost.localdomain> (sfid-20081215_190109_958887_3179D2C6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-15 at 17:14 +0000, Tony Vroon wrote:
> On Mon, 2008-12-15 at 10:19 -0500, Dan Williams wrote:
> > I plan to beat the shit out of the hal killswitch support pretty soon.
> > AFAIK it still doesn't know about softblock, which is part of the whole
> > reason for the rfkill rewrite in 2.6.26 anyway.  It also doesn't yet
> > (AFAIK) support uevents from killswitches either, which sucks.
> 
> Thanks Dan.
> Could you let me know when you've committed this code so I have another
> shot at implementing rfkill reporting in fujitsu-laptop?

Yeah, though the HAL support will be coded to the kernel rfkill devices,
so if the platform or the wifi driver supports the kernel rfkill
interface, the HAL bits should work.

> P.S. Did you get my e-mail about the Sierra Wireless MC8790?

Yes; it's hal-info commit 8912ec2b5d0a221a74156c047b18a26b2d916e13.

Dan


