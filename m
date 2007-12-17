Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2251 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbXLQP3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 10:29:48 -0500
Date: Mon, 17 Dec 2007 09:48:59 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
Subject: Re: [patch 4/9] mac80211: Make PID rate control algorithm the
	default
Message-ID: <20071217144859.GB3121@tuxdriver.com> (sfid-20071217_152952_593077_593131D2)
References: <20071217001956.640555983@gmx.de> <20071217002056.351743954@gmx.de> <1197852547.4885.1.camel@johannes.berg> <20071217015004.2400ab33@morte> <1197852873.4885.2.camel@johannes.berg> <20071217015748.5bb3f7fc@morte> <1197853758.4885.4.camel@johannes.berg> <1197885374.7514.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197885374.7514.6.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 17, 2007 at 10:56:14AM +0100, Mattias Nissler wrote:
> 
> On Mon, 2007-12-17 at 02:09 +0100, Johannes Berg wrote:
> > > That was my original proposal, but during a recent discussion John
> > > suggested not to remove rc80211-simple right now, as it's currently
> > > almost working for a lot of people. John, any suggestions?
> > 
> > Those people can fix the bitrate at 1M if the pid algorithm becomes
> > problematic, that's what simple currently does in practice.
> 
> Agreed. So what flavour of this patch do you want? John?

My "Spidey sense" tells me it would be good to keep the old one around
for a little while... :-)

Besides, as we have seen recently people often get quite upset when
you remove a feature that they perceive to be working for them --
no matter how much better the alternative may be.  It would be better
to give them some warning.

John
-- 
John W. Linville
linville@tuxdriver.com
