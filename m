Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:56407 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373AbZHWO1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Aug 2009 10:27:03 -0400
Date: Sun, 23 Aug 2009 10:27:24 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: G?bor Stefanik <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Richard Farina <sidhayn@gmail.com>,
	Sam Leffler <sam@freebsd.org>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	Damien Bergamini <damien.bergamini@free.fr>,
	Sepherosa Ziehau <sepherosa@gmail.com>,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>,
	radiotap <radiotap@radiotap.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	freebsd-mobile <freebsd-mobile@freebsd.org>,
	misc-openbsd <misc@openbsd.org>, tech-openbsd <tech@openbsd.org>,
	netbsd-net <tech-net@netbsd.org>,
	wireshark-dev <wireshark-dev@wireshark.org>
Subject: Re: Plans for an online meeting regarding Radiotap
Message-ID: <20090823142724.GA29917@drd1813>
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <4A8EAFA6.9010608@gmail.com>
 <1250865255.4600.6.camel@johannes.local>
 <69e28c910908210741wd3bc391x311523f5b55fd4f1@mail.gmail.com>
 <1250865918.4600.9.camel@johannes.local>
 <69e28c910908210804h6181aab1w4a864392239aa1ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
In-Reply-To: <69e28c910908210804h6181aab1w4a864392239aa1ac@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 21, 2009 at 05:04:20PM +0200, G?bor Stefanik wrote:
> > Besides,
> > you're supposed to make at least two implementations when proposing a
> > standard field.
>=20
> If I remember correctly, I made an implementation for the Linux kernel
> (a generator-side implementation) and one for Wireshark (a parser-side
> implementation). Or should I make two generator-side implementations
> according to the requirement (e.g. one for Linux, another for
> OpenBSD)?

Once there's a spec that's a little more stable I can add it to lorcon, so
that will give you 2 userspace implementations for tx (assuming aircrack
adopts it) with different authors.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"A baby seal walks into a club..."

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkqRUcwACgkQ17KIInOLvbHnEwCgtNpP2szed35FZIurTJJ+Ixix
VqAAn2std79YDlBkC+scYtfesZA6BT+o
=E+r3
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
