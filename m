Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41092 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126AbZAWQEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:04:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Regression caused by commit e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
Date: Fri, 23 Jan 2009 17:03:28 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Alina Friedrichsen <x-alina@gmx.net>, samuel@sortiz.org,
	Kalle Valo <kalle.valo@iki.fi>, maximlevitsky@gmail.com,
	wireless <linux-wireless@vger.kernel.org>
References: <4979269F.1060500@lwfinger.net> <200901231647.50978.mb@bu3sch.de> <20090123154918.GB13658@tuxdriver.com>
In-Reply-To: <20090123154918.GB13658@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901231703.28904.mb@bu3sch.de> (sfid-20090123_170428_050822_BB4E3474)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 16:49:18 John W. Linville wrote:
> On Fri, Jan 23, 2009 at 04:47:50PM +0100, Michael Buesch wrote:
> > On Friday 23 January 2009 03:08:31 Larry Finger wrote:
> > > With the commit of the subject, my b43 and p54usb devices stopped working. They could
> > > associate and authenticate with my WPA2 network, but never finish the DHCP connection and
> > > get an IP address. Surprisingly, my rtl8187 devices continued to work.
> > > 
> > > Please excuse the second sending of this. I missed wireless the first time.
> > 
> > Do you have a diff of this commit? Or at least the date it was committed?
> > I have some strange AP mode issue and it might be related to this. I just want to verify.
> 
> That commit ID should still be available in wireless-testing --
> git show e32b1b9a33759e8a83ac566c4c43f23ed5d6343b

Oh ok. I thought you just took it out and rebased.
Thanks :)

-- 
Greetings, Michael.
