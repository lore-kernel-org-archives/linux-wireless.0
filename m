Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbXIELVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 07:21:51 -0400
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20070905024930.GG5273@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg>
	 <20070904011648.GX1835@jm.kir.nu> <1188913335.9942.16.camel@johannes.berg>
	 <20070905024930.GG5273@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hfz/hah339ZjD0avv7Uk"
Date: Wed, 05 Sep 2007 13:22:04 +0200
Message-Id: <1188991324.9942.95.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hfz/hah339ZjD0avv7Uk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-04 at 19:49 -0700, Jouni Malinen wrote:
> On Tue, Sep 04, 2007 at 03:42:15PM +0200, Johannes Berg wrote:
> > On Mon, 2007-09-03 at 18:16 -0700, Jouni Malinen wrote:
> > > Where are things like NL80211_ATTR_IFNAME and
> > > NL80211_CMD_ADD_VIRTUAL_INTERFACE defined? I would assume these are f=
rom
> > > linux/nl80211.h, but where should I get the version that includes the=
se?
> >=20
> > You have to use the one from wireless-dev as we don't ship it from
> > mainline yet.
>=20
> I was trying to use wireless-dev.. Which branch includes the values
> shown above? I don't see them in either master or even everything..
> (git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git)

It should be in 'everything' in include/linux/nl80211.h

> OK. If there were a pre-release version, that would likely make this
> quite a bit easier. Gentoo actually includes 1.0-pre6 which is the
> latest pre-release and as such, I was kind of hoping for it to be new
> enough. Then again, once I looked at the release date, I noticed it's
> already a year old.. I don't really want to depend on this unless there
> is a good likelyhood of there being a proper release with the needed
> functionality in somewhat near future.

Up to Thomas, I guess.

johannes

--=-Hfz/hah339ZjD0avv7Uk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3pFc/ETPhpq3jKURAqDjAJwPUJmCdoqaLn1B2wsQkkG3IDUfUwCfU9nt
ohgoO5w8ZLm5Z+7IWVpfcjc=
=4Lv3
-----END PGP SIGNATURE-----

--=-Hfz/hah339ZjD0avv7Uk--

