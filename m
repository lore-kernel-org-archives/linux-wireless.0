Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbZHUOpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 10:45:24 -0400
Subject: Re: Plans for an online meeting regarding Radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Richard Farina <sidhayn@gmail.com>,
	Mike Kershaw <dragorn@kismetwireless.net>,
	Sam Leffler <sam@freebsd.org>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	Damien Bergamini <damien.bergamini@free.fr>,
	Sepherosa Ziehau <sepherosa@gmail.com>,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>,
	Dave Young <hidave.darkstar@gmail.com>,
	radiotap <radiotap@radiotap.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	freebsd-mobile <freebsd-mobile@freebsd.org>,
	misc-openbsd <misc@openbsd.org>, tech-openbsd <tech@openbsd.org>,
	netbsd-net <tech-net@netbsd.org>,
	wireshark-dev <wireshark-dev@wireshark.org>
In-Reply-To: <69e28c910908210741wd3bc391x311523f5b55fd4f1@mail.gmail.com>
References: <4A8EAFA6.9010608@gmail.com>
	 <1250865255.4600.6.camel@johannes.local>
	 <69e28c910908210741wd3bc391x311523f5b55fd4f1@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JaV4Oxpf3uVUP0bg8tdb"
Date: Fri, 21 Aug 2009 16:45:18 +0200
Message-Id: <1250865918.4600.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JaV4Oxpf3uVUP0bg8tdb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 16:41 +0200, G=C3=A1bor Stefanik wrote:

> My intention with the meeting is to form an actual proposal that all
> implementors can agree on. We can produce proposals, and even new
> standardized fields to no avail, as some implementors (especially
> OpenBSD) appear to be stuck with implementations that collide with the
> standard. These implementors need to be "awakened" and entered into
> the discussions before anything can be done.

There's nothing the standard can do about that. Like I said, we've
talked about that enough in my opinion.

> > Your own proposal had technical flaws (and in my opinion tried to do to=
o
> > much at a time) that you haven't addressed -- doing that would be much
> > more productive than any such meeting.
>=20
> What technical flaws are you trying to point out exactly? (The TX
> flags field? My point is that it's worthless to "standardize" TX flags
> by extending it and moving to "Defined fields" if noone is willing to
> implement it.)

But people are already implementing it, and if they do something else
that's their problem. The flaw I'm thinking of was over the RTS/CTS
handling where some people (including myself) had comments. Besides,
you're supposed to make at least two implementations when proposing a
standard field.

johannes

--=-JaV4Oxpf3uVUP0bg8tdb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjrL7AAoJEODzc/N7+QmahHIP/1MlzeKmu9boxW2wEDfO/0gn
td56z1fQ1NabN43P/bzwVih9Ia8aa5Z1JVDV7MARTkFRtHdPpuOhgA9h6D6aAzKv
HeZXyigvajRpMbn2i8t4ZFWull6E4ROoglZKtUsVg1acoPZyBCUl4Zu/DOOViEvk
FLLLOF50LD6/OGin4g4nrLD2OLo4NDFXOwdUDneJrJVnPnnJAzI/49f5DnPpmOK2
i7XfD/OHCyIT5VJsDV1+gCDav5Rvmync9dkle3NiENZareINrTc+QtyFdXlQbDyx
btl+Ha/ZDL2GwYq36wrTOAyu01C3jF8uhpb+cim19VTAUImQXxad+EonIXh3rjo0
JU2xaLFITadjEf9lwnnXwBmmJpMCdZMYRsDE2Iq4fHnhyDcj5Zye0CI6GGa00DHP
P3+O6iKsbci/67eQJNvirVUEk6QihLPizpxaQwiJ8EQGUSUQegoIQ/HHePn9v/Ph
ZTNBoCcZNyeaDBQZQeG61xNQyNXl93hg0FvvB5eRhVZIEWuTu1WYWYikKSvPVERE
Zgrmar4NssmASwpbojMtO3uUtjv9f/O0wFNwcUtk4YZ9srZdJaDBojzAmvigmPVa
xUGVQU+rt0UF9GnEov8VkRbcQrXqP2RLDbSWp04Wq8qgWBlrzcxSzItdgC/ktDpZ
1SKhTx1lbDAYQr+0bbMB
=QXFI
-----END PGP SIGNATURE-----

--=-JaV4Oxpf3uVUP0bg8tdb--

