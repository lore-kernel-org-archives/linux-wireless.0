Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688AbXGKJgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 05:36:21 -0400
Subject: Re: [PATCH 00/14] major mac80211 restructuring/cleanups
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
In-Reply-To: <20070710171216.GE7927@tuxdriver.com>
References: <20070621221603.778432000@sipsolutions.net>
	 <20070710153456.471e395e@logostar.upir.cz>
	 <1184075439.15565.11.camel@johannes.berg>
	 <20070710162912.17899683@logostar.upir.cz>
	 <1184079079.15565.13.camel@johannes.berg>
	 <20070710171216.GE7927@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-slYSSkGYSjL0Fk31Vzbj"
Date: Tue, 10 Jul 2007 20:35:00 +0200
Message-Id: <1184092500.3738.15.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-slYSSkGYSjL0Fk31Vzbj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-10 at 13:12 -0400, John W. Linville wrote:

> > > which is not upstream. Merging it upstream would mean taking the patc=
h from
> > > wireless-dev git and manually modifying it to fit a new structure. An=
d we
> > > have a bunch of such patches which should go to 2.6.24 (yes, I really
> > > mean .24). Perhaps I'm lazy, but I'd like to avoid that. It's going t=
o be a
> > > lot of unpleasant work even without this...

> Hmmmm...maybe.  But, what would have been the perfect trigger to
> merge it?  At least now we have less bits out-of-stream and have to
> do less API-chasing with every new kernel.

Dunno. I guess I didn't expect Jiri to block any patches based on the
fact that we have two trees now.

I don't really see the big problem anyhow. As long as we don't want any
patches in upstream that depend on the refactoring we can delay pushing
the refactoring upstream. Once we do get patches we can decide to either
make two versions of them or at some point push the refactoring upstream
as well; problems will only arise if we delay too much pushing patches
upstream that are before the refactoring, those would need to be
rediffed.

Oh well. Do what you feel is easiest. This is the second or third time
I've been burnt with significant mac80211 cleanups so I guess I'll just
learn my lesson here.

johannes

--=-slYSSkGYSjL0Fk31Vzbj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGk9FU/ETPhpq3jKURAv+sAKCDgza+lVe9oxyIi/dh5jXQbsgqTACdHQEY
//2uVIaD5jOVoYLCcpluIz8=
=E0JI
-----END PGP SIGNATURE-----

--=-slYSSkGYSjL0Fk31Vzbj--

