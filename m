Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [12.19.149.2] ([12.19.149.2]:62266 "EHLO mail.atheros.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0HWRvX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:51:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:51:19 -0700
Date: Mon, 23 Aug 2010 10:46:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bastien Nocera <hadess@hadess.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kevin Hayes <kevin@Atheros.com>,
	David Quan <David.Quan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"geoclue@lists.freedesktop.org" <geoclue@lists.freedesktop.org>
Subject: Re: [PATCH 0/2] iw: add GeoClue support
Message-ID: <20100823174620.GA12375@tux>
References: <1282350556-16523-1-git-send-email-lrodriguez@atheros.com>
 <1282572681.3813.3.camel@jlt3.sipsolutions.net>
 <AANLkTimrtWQKycuAcZ3SjDaOqJ6Z-pPNauRfh+2aZ=ge@mail.gmail.com>
 <1282579507.3405.130.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1282579507.3405.130.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 23, 2010 at 09:05:07AM -0700, Bastien Nocera wrote:
> On Mon, 2010-08-23 at 08:44 -0700, Luis R. Rodriguez wrote:
> > 
> > > What use is a command line tool that has to talk to a whole bunch of
> > > daemons etc.?
> > 
> > The current implementation doesn't talk to deamons. The hostip
> > provider within GeoClue and it will just trigger a URL get. If
> > desktops start implementing a master server though then the query
> > would simply be a cached response. 
> 
> Note that this error carries on in the mail. There is a master provider
> for Geoclue that can make use of whatever providers are available, but
> it's not in too good a shape.

I see, can you elaborate on that a little?

> I'd rather somebody started fixing the Geoclue master provider rather
> than relying on a particular service, especially when the D-Bus API for
> the providers themselves is something we don't want to support in the
> longer term.

Would the master provider not use Dbus for gypsy, for example?

  Luis
