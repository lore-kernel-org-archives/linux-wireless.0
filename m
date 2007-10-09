Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:55413 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXJINzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 09:55:47 -0400
Date: Tue, 9 Oct 2007 09:55:38 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Mode selection in mac80211
Message-ID: <20071009135538.GA29748@drd1813.lan> (sfid-20071009_145549_626510_24E7FEC2)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <200710052319.10600.linux@baker-net.org.uk> <1191837339.4063.25.camel@johannes.berg> <20071008143207.GB7430@drd1813.lan> <1191921702.4013.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
In-Reply-To: <1191921702.4013.15.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 09, 2007 at 11:21:42AM +0200, Johannes Berg wrote:
> On Mon, 2007-10-08 at 10:32 -0400, Mike Kershaw wrote:
>=20
> > I'd vote for allowing the user to set a mode - just like they're
> > allowed to lock an AP association to a specific MAC, bypassing the
> > hardware roaming algos.
> >=20
> > I've hit situations in the past where a card can get a very weak 11g
> > link but a perfectly usable 11b link, and the hw did not want to drop
> > back to 11b on its own.  Being able to lock to 11b only was key. =20
>=20
> Actually, what you're advocating sounds like "please let me restrict the
> bitrates to use" rather than "please lock me to a mode". And we need
> that functionality anyway for AP mode.

Not quite, I've had situations where 9mbit at OFDM (11g) performed=20
differently than 11mbit at CCK (11b) for whatever reason.  I'm also
fairly sure several cards (I want to say Intel 2200?) limit the max tx
power differently depending on the encoding type (100mW for 11b vs.
something less I don't remember off hand for 11g).

Just seems like useful functionality that it'd be a shame to lose.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

There's too much blood in my caffeine system!

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHC4ha17KIInOLvbERAtrkAJ0cFyE6881Mbdv+2Gj8FR0wlLIbvACg5HSU
CMqG1wrEA9kUM3mavUsKHCs=
=j9ZV
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
