Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:42374 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYIPJcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:32:12 -0400
From: Helmut Schaa <hschaa@suse.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Tue, 16 Sep 2008 11:32:10 +0200
Cc: Kalle Valo <kalle.valo@nokia.com>,
	"Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <87fxo0zee1.fsf@nokia.com> <200809161050.41482.hs4233@mail.mn-solutions.de>
In-Reply-To: <200809161050.41482.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809161132.10454.hschaa@suse.de> (sfid-20080916_113215_284578_B4006A4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 16. September 2008 10:50:41 schrieb Holger Schurig:
> On Tuesday 16 September 2008 10:25:10 Kalle Valo wrote:
> >> My main problem is that adding a beacon threshold to mac80211
> >> isn't a
> >
> > Still I don't see a problem here, all the mac80211 drivers
> > should already now report similar signal strenght to the
> > mac80211 in comparable level.
>
> And we could later allow something similar to "iwconfig ethX sens
> Y" to modify the the threshold (or whatever else we use, even
> some arbitrary calculated quality value). The possibility to
> modify this would allow the user to define how eager mac80211 is
> when it comes to roaming.

That would be nice, yes. If the user knows that only one AP is around and 
roaming will never be successful he should have the possibility to turn 
background scanning/roaming off. However implementing that for nl80211 should 
suffice. No need to extend wext here.

Helmut
