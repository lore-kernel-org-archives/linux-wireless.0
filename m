Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYIPJUN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:20:13 -0400
From: Helmut Schaa <hschaa@suse.de>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] Implement basic background scanning
Date: Tue, 16 Sep 2008 11:20:09 +0200
Cc: "Kalle Valo" <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
References: <200809151416.07552.hschaa@suse.de> <877i9czdjd.fsf@nokia.com> <b2d017be9e6908538faef3d96845500c.squirrel@secure.sipsolutions.net>
In-Reply-To: <b2d017be9e6908538faef3d96845500c.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809161120.09728.hschaa@suse.de> (sfid-20080916_112016_420665_E0128484)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 16. September 2008 11:10:10 schrieb Johannes Berg:
> Kalle Valo wrote:
> > Helmut Schaa <hschaa@suse.de> writes:
> >>> This doesn't play well at all with hardware assisted scan as far as I
> >>> can tell.
> >>
> >> Correct. The patch only adapts software scan code. The hardware
> >> assisted scan is not touched at all but should also not be affected
> >> in an odd way.
> >
> > I would guess that some firmwares support similar scanning in
> > hardware. In the future we might add support for background scanning
> > in hardware with a flag in hw_scan(), or something like that.
>
> I don't want to see this implemented without taking into account hw scan
> offload from the start.

Ok, would you accept a hardware flag that indicates if a card is able to
do background scanning? And if the flag is not set we could just use a 
software background scan as fallback?

Helmut
