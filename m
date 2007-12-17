Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:52889 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934089AbXLQULd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 15:11:33 -0500
Date: Mon, 17 Dec 2007 21:06:49 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
 default
Message-ID: <20071217210649.370ba385@morte> (sfid-20071217_201159_062539_E24A3CC2)
In-Reply-To: <20071217150202.GC3121@tuxdriver.com>
References: <20071217012517.882216322@gmx.de>
	<20071217012550.213561122@gmx.de>
	<20071217150202.GC3121@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 17 Dec 2007 10:02:02 -0500
"John W. Linville" <linville@tuxdriver.com> wrote:

> On Mon, Dec 17, 2007 at 02:25:21AM +0100, Mattias Nissler wrote:
> 
> >  config MAC80211_RCPID
> > -	bool "'PID' rate control algorithm" if EMBEDDED
> > +	bool "'PID' rate control algorithm"
> 
> Shouldn't this keep the "if EMBEDDED"?  Especially if it is going to be the default?

How is EMBEDDED supposed to be related to this? Anyway, I'll go for the two
modules approach, forcing one module to be selected.

> > -What:	iee80211 softmac wireless networking component
> > +What:	ieee80211 softmac wireless networking component
> >  When:	2.6.26 (or after removal of bcm43xx and port of zd1211rw to mac80211)
> >  Files:	net/ieee80211/softmac
> >  Why:	No in-kernel drivers will depend on it any longer.
> >  Who:	John W. Linville <linville@tuxdriver.com>
> 
> These typo fixes seem fine, but they should be in a seperate patch.

I actually thought that this was a common and accepted practice. A separate
patch will be sent.


--
Ciao
Stefano
