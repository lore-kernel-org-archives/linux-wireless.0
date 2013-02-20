Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50261 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933833Ab3BTDNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 22:13:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
Message-ID: <20772.16150.250544.138025@gargle.gargle.HOWL> (sfid-20130220_041354_065052_D0527F61)
Date: Wed, 20 Feb 2013 08:42:22 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Adrian Chadd <adrian@freebsd.org>
Cc: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru>
	<20130219134028.GA26332@pandem0nium>
	<alpine.DEB.2.02.1302191752110.31254@icf.org.ru>
	<CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
	<alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
	<CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com>
	<20771.50338.434076.484711@gargle.gargle.HOWL>
	<CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com>
	<20771.51233.248133.141840@gargle.gargle.HOWL>
	<alpine.DEB.2.02.1302192258510.19584@icf.org.ru>
	<CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> Yes. I've seen cards that do this. It's almost always due to badly
> placed components/tracks causing spurs / resonance to show up in the
> 2GHz bands.
> It makes the NIC unusable in those modes.

This issue happens on a variety of cards (with ath9k). I think this
might be just a driver bug.

Sujith
