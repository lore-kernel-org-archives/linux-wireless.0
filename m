Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2764 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbXBMVic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Feb 2007 16:38:32 -0500
Date: Tue, 13 Feb 2007 16:13:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Miles Lane <miles.lane@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: RFT: The real fix for BCM4311 and BCM4312
Message-ID: <20070213211340.GG3572@tuxdriver.com>
References: <45C96B8A.8010000@lwfinger.net> <1170830071.11150.62.camel@dv> <200702071443.19676.rjw@sisk.pl> <45C9D9D6.2070700@lwfinger.net> <a44ae5cd0702101530j38c983bfy9c1496fd50ca8b1c@mail.gmail.com> <45CE5812.3000306@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45CE5812.3000306@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 10, 2007 at 05:41:06PM -0600, Larry Finger wrote:
> Miles Lane wrote:
> > I am testing this patch applied to the wireless-net git tree.
> > The card is a Linksys WPC54G.  The card is still getting very
> > weak signal strength and the connection seems unresponsive
> > most of the time.
> 
> As the subject says, the patch was for 4311 and 4312 cards. The 4318's are not yet fixed.
> 
> As measured by my RF receiver, the amplitude of the 4318 is about -70 dBm, the 4311 is about -60 dBm
> and the 4306 is -50 dBm. All should have the -50 reading with my test setup.
> 
> I'm working on the power routines and will let you know.

FWIW, this patch seems to have helped some BCM4311 and BCM4312 wielding
Fedora users.

John
-- 
John W. Linville
linville@tuxdriver.com
