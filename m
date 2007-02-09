Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946606AbXBIPq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 10:46:57 -0500
Subject: Re: [RFC PATCH 3/3] cfg80211: add wext-compatible client
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890702081141j168da47i421f4fe578a08735@mail.gmail.com>
References: <20070131013717.GA28076@tuxdriver.com>
	 <20070207004626.GA23096@tuxdriver.com>
	 <20070207004747.GB23096@tuxdriver.com>
	 <20070207004832.GC23096@tuxdriver.com>
	 <20070207004929.GD23096@tuxdriver.com>
	 <20070207075420.GB14703@infradead.org>
	 <1170940386.4385.49.camel@johannes.berg>
	 <43e72e890702081038k1d4f226eocf28c5faf6b79dc5@mail.gmail.com>
	 <20070208185050.GA6303@tuxdriver.com>
	 <43e72e890702081141j168da47i421f4fe578a08735@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n547i6SsE2Z7N0mSai5y"
Date: Fri, 09 Feb 2007 16:43:56 +0100
Message-Id: <1171035836.4520.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n547i6SsE2Z7N0mSai5y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-08 at 14:41 -0500, Luis R. Rodriguez wrote:
> On 2/8/07, John W. Linville <linville@tuxdriver.com> wrote:
> > On Thu, Feb 08, 2007 at 01:38:02PM -0500, Luis R. Rodriguez wrote:
> > > On 2/8/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > >On Wed, 2007-02-07 at 07:54 +0000, Christoph Hellwig wrote:
> > > >> Btw, if we submit cfg80211 for inclusion there should be at least =
one
> > > >patch
> > > >> in the series actually converts a driver to use it.  Both to make =
this
> > > >> code not dead and give people and example on how to use the cfg802=
11
> > > >> infrastructure.
> > > >
> > > >I guess I could make softmac use it.
> > >
> > > Another idea here is we can provide a configfs frontend to cfg80211
> > > therefore any device which implements cfg80211 will automagically hav=
e
> > > a userspace frontend (/configfs/wireless/foo) ready to test cfg80211.
> > > With this we wouldn't have to wait for the next userspace nl80211
> > > application to start testing cfg80211 directly (without wireless
> > > extensions compat). A configfs frontend can also allow more rapid
> > > development of userspace interfaces to configure wireless devices
> > > through cfg80211. Comments?
> >
> > Luis,
> >
> > You have mentioned this before, and FWIW I think it is a decent idea.
> > Let's see some code! :-)
>=20
> I know, I know, talk is cheap, trust me, I abide by this motto every
> day. I actually wanted to just code this up and send this as part of
> my comment but do have other responsibilities I have to attend to
> first. I figured I'd throw it out though in case someone who does have
> time is willing to pick it up as I think it would be great for us.

Last time I tried configfs didn't support the group commit stuff yet so
it'd be only useful for *showing* things rather than changing...

johannes

--=-n547i6SsE2Z7N0mSai5y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFzJa8/ETPhpq3jKURAmnDAKCxORCgiVf/eiGoEpVtZDYJxuWuCQCfdcBW
vz8T3ojpyVsMK/vjYgmnDj8=
=GIi3
-----END PGP SIGNATURE-----

--=-n547i6SsE2Z7N0mSai5y--

