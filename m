Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60359 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbZAWQAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:00:49 -0500
Date: Fri, 23 Jan 2009 10:49:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Alina Friedrichsen <x-alina@gmx.net>, samuel@sortiz.org,
	Kalle Valo <kalle.valo@iki.fi>, maximlevitsky@gmail.com,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression caused by commit
	e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
Message-ID: <20090123154918.GB13658@tuxdriver.com> (sfid-20090123_170111_635348_57463943)
References: <4979269F.1060500@lwfinger.net> <200901231647.50978.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901231647.50978.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 04:47:50PM +0100, Michael Buesch wrote:
> On Friday 23 January 2009 03:08:31 Larry Finger wrote:
> > With the commit of the subject, my b43 and p54usb devices stopped working. They could
> > associate and authenticate with my WPA2 network, but never finish the DHCP connection and
> > get an IP address. Surprisingly, my rtl8187 devices continued to work.
> > 
> > Please excuse the second sending of this. I missed wireless the first time.
> 
> Do you have a diff of this commit? Or at least the date it was committed?
> I have some strange AP mode issue and it might be related to this. I just want to verify.

That commit ID should still be available in wireless-testing --
git show e32b1b9a33759e8a83ac566c4c43f23ed5d6343b

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
