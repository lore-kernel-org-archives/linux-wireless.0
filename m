Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41383 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYKSVQC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 16:16:02 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Nov 2008 13:16:02 -0800
Date: Wed, 19 Nov 2008 13:16:00 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Rami Rosen <ramirose@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kune@deine-taler.de" <kune@deine-taler.de>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
Message-ID: <20081119211600.GE5900@tesla> (sfid-20081119_221608_485440_663C01E4)
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com> <1226943608.3902.36.camel@johannes.berg> <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com> <1227106146.26243.43.camel@johannes.berg> <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com> <1227107869.26243.52.camel@johannes.berg> <20081119160135.GB3485@tuxdriver.com> <1227126620.26243.71.camel@johannes.berg> <20081119210046.GC5900@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081119210046.GC5900@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 01:00:46PM -0800, Luis Rodriguez wrote:
> On Wed, Nov 19, 2008 at 12:30:19PM -0800, Johannes Berg wrote:
> > On Wed, 2008-11-19 at 11:01 -0500, John W. Linville wrote:
> >
> > > Is there some way we could take that into account?  I'm sure there
> > > are users who would prefer to have an AP (i.e. their laptop) that
> > > can't support PS clients rather than not having an AP at all.
> >
> > That's a good question. The distinction here is between empowering users
> > to do the wrong thing (AP without proper PS support) and enforcing the
> > right thing (with the consequence of complete loss of AP functionality).
> > The issue I see here is that users will see "ohh shiny, AP support"
> > without knowing that it doesn't actually really support it. Not sure
> > which side of the line we want to stand on, I prefer the correctness
> > side but I can see arguments for the other side, would just like to have
> > users know. Maybe we could have some way to tell hostapd this and then
> > have hostapd print a huge warning about it when started up?
> 
> How about making it Kconfigable for broken AP support and add the
> warning there?

That is have something like CONFIG_MAC80211_AP_HALF_ASSED

  Luis
