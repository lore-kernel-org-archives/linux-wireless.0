Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34312 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685AbbGEKda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 06:33:30 -0400
Message-ID: <1436092402.6268.0.camel@sipsolutions.net> (sfid-20150705_123334_272627_FAD9998B)
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonas Gorski <jogo@openwrt.org>, David Lin <dlin@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Sun, 05 Jul 2015 12:33:22 +0200
In-Reply-To: <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
	 <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not so sure about the OF thing - at least in general this seems
right and many drivers are selecting OF. If that causes issues on
certain platforms then perhaps those platforms should fix the issues,
or the whole OF should be changed to depends on?

> > --- /dev/null
> > +++ b/drivers/net/wireless/mwlwifi/MAINTAINERS
> > @@ -0,0 +1,5 @@
> > +MARVELL MWLWIFI WIRELESS DRIVER
> > +M:     David Lin <dlin@marvell.com>
> > +L:     linux-wireless@vger.kernel.org
> > +S:     Maintained
> > +F:     drivers/net/wireless/mwlwifi/
> 
> Please add this to the top directory MAINTAINERS instead of adding a
> separate file (unless adding your own MAINTAINERS is the new thing).
> 

Indeed, good catch.

johannes
