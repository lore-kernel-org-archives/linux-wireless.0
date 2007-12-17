Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33432 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751864AbXLQAyK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 19:54:10 -0500
Date: Mon, 17 Dec 2007 01:50:04 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: mattias.nissler@gmx.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
 default
Message-ID: <20071217015004.2400ab33@morte> (sfid-20071217_005413_648345_538A87E5)
In-Reply-To: <1197852547.4885.1.camel@johannes.berg>
References: <20071217001956.640555983@gmx.de>
	<20071217002056.351743954@gmx.de>
	<1197852547.4885.1.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 17 Dec 2007 01:49:06 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> > -What:	iee80211 softmac wireless networking component
> > +What:	ieee80211 softmac wireless networking component
> 
> 
> Unrelated change, please separate.

Will do.
 
> > +
> > +What:	rc80211-simple rate control algorithm for mac80211
> > +When:	2.6.26
> > +Files:	net/mac80211/rc80211-simple.c
> > +Why:	This algorithm was provided for reference but always exhibited bad
> > +	responsiveness and performance and has some serious flaws. It has been
> > +	replaced by rc80211-pid.
> > +Who:	Stefano Brivio <stefano.brivio@polimi.it>
> 
> I don't think we really want to do this. We can't even change the
> algorithm anyway except by recompiling with a different default.

What do you suggest instead?


--
Ciao
Stefano
