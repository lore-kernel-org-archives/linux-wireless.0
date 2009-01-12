Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47236 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbZALPpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 10:45:50 -0500
Date: Mon, 12 Jan 2009 10:39:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Lorenzo Nava <navalorenx@gmail.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Michael Buesch <mb@bu3sch.de>,
	Gringoli PhD Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [b43] opensource firmware
Message-ID: <20090112153949.GC31525@tuxdriver.com> (sfid-20090112_164601_965758_6FC25554)
References: <200901091129.22708.mb@bu3sch.de> <200901091149.28683.mb@bu3sch.de> <9F70A0D3-6334-45FB-9DAF-263FE89C847E@ing.unibs.it> <200901091206.09736.mb@bu3sch.de> <AE7A4FD8-1728-4CE2-8CC7-DCE699C3B6C9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AE7A4FD8-1728-4CE2-8CC7-DCE699C3B6C9@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 10, 2009 at 06:37:43PM +0100, Lorenzo Nava wrote:
> Hello everybody,
>
> today I tried OpenFWWF with kernel 2.6.28 on a Siemens wifi device with 
> Broadcom 4306 chipset:
>
> BCM94306 802.11g (rev 03)
> PHY: Analog 2, Type 2, Revision 2
> Radio: Manuf 0x17F, Version 0x2050, Revision 2
>
> I did some tests and everything seems to work fine.
>
> I remember, once again, that OpenFWWF needs v480 initvals to work  
> properly, and was tested on 2.6.27-rc5 kernel.

Any chance on getting a set of initvals packaged with the open source
firmware?  That would allow distros like Fedora to package this...

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
