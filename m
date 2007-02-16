Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:57886 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946163AbXBPUuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 15:50:17 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 09/10] cfg80211: pending config
Date: Fri, 16 Feb 2007 15:49:52 -0500
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
References: <20070215144241.847938000@sipsolutions.net> <20070215144300.419560000@sipsolutions.net> <1171653056.4153.38.camel@localhost.localdomain>
In-Reply-To: <1171653056.4153.38.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5075388.6eEOyqKOtR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702161549.52856.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5075388.6eEOyqKOtR
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 16 February 2007 14:10, Dan Williams wrote:
> > --- wireless-dev.orig/include/net/cfg80211.h	2007-02-15
> > 13:23:41.967940064 +0100 +++
> > wireless-dev/include/net/cfg80211.h	2007-02-15 13:23:43.707940064 +0100
> > @@ -11,6 +11,8 @@
> >   * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
> >   */
> >
> > +#define SSID_MAX_LEN	32
> > +
>
> This has _got_ to be defined somewhere else in the stack?  Can we use
> that define, or is it being moved to here?  Seems a shame to have it
> more than one place.
>
> On a side note, many many drivers need something like this, and many
> many drivers redefine it internally.  Is there some header that all
> drivers (even fullmac like airo, orinoco, atmel, and libertas) can get
> this from?
>
That's what include/linux/ieee80211.h is (or will be) for.

-Michael Wu

--nextPart5075388.6eEOyqKOtR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF1hjwT3Oqt9AH4aERAhs7AJ44ApLoboNbbsijMzjbm7AwJ+dgdACeJ4+o
QOM2WEK3qPsQoDA+HYIvr3k=
=Tn4Z
-----END PGP SIGNATURE-----

--nextPart5075388.6eEOyqKOtR--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
