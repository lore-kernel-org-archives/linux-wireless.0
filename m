Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv04.lahn.de ([213.239.197.57]:37825 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbYF2WRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2008 18:17:47 -0400
Date: Mon, 30 Jun 2008 00:17:57 +0200
From: Michael Leun <linux-wireless@newton.leun.net>
To: Filippo Zangheri <filippo.zangheri@yahoo.it>
Cc: linux-wireless@vger.kernel.org
Subject: Re: compat wireless, i3945, tcpdump: Machine freezes
Message-ID: <20080630001757.2489b72c@localhost> (sfid-20080630_001751_640700_20EECB41)
In-Reply-To: <48660294.2010405@yahoo.it>
References: <20080618094213.5abd2fbd@localhost>
	<20080625154354.719cc9b3@localhost>
	<1214442132.14590.282.camel@debian.sh.intel.com>
	<20080627200417.22d3488b@localhost>
	<48660294.2010405@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Sat, 28 Jun 2008 11:21:24 +0200
Filippo Zangheri <filippo.zangheri@yahoo.it> wrote:

> >>>> I downloaded compat-wireless-2008-06-18, built it, loaded
> >>>> cfg80211.ko, mac80211.ko, iwl3945.ko, associated to an ap,
> >>>> started "tcpdump -i wlan0 -n" and the machine mostly freezed.
> >>>>
> >>>> Mostly means keyboard does not work, no disk-access, no network
> >>>> but mouse still works.
> >>> This still happens with compat-wireless-2008-06-25.
> >> We have a fix patch here. Will submit to linux-wireless after some
> >> tweak.
> >> http://article.gmane.org/gmane.linux.drivers.ipw3945.devel/3166
> > 
> > Yup, that works - does not freeze anymore. But when switching
> > promiscuous on it reassociates and there is a network outage of
> > several seconds.
> > 
> > Thanks!
> > 
> 
> Try this patch. It fixed this problem for me.

Yes, this works for me too. Thanks!

-- 
Bye,

Michael Leun

