Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZG0Uc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 16:32:57 -0400
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Johannes Berg <johannes@sipsolutions.net>
To: chris2553@googlemail.com
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200907272122.11290.chris2553@googlemail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <200907272035.41193.chris2553@googlemail.com> <1248725279.7440.8.camel@mj>
	 <200907272122.11290.chris2553@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qUjUA8bTeDAgxxMmAVJ0"
Date: Mon, 27 Jul 2009 22:32:24 +0200
Message-Id: <1248726744.32365.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qUjUA8bTeDAgxxMmAVJ0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 21:22 +0100, Chris Clayton wrote:

> Yes, I remove the card once the laptop has frozen, because doing so "thaw=
s" it again. The laptop is=20
> then usable until 2-5 minutes after I insert the card again, when it will=
 freeze again. I can=20
> repeat this cycle over and over.

That really points to a hw (or hw programming) bug that causes the card
to lock up the bus. Had that many times in early b43 days.

> > It looks like a problem specific to the hardware, not anything in the
> > common wireless code.  I suggest that you post your question to
> > users@rt2x00.serialmonkey.com.  That's the mailing list for rt61pci and
> > other Ralink devices.
>=20
> I think I'll just configure MAC80211 power saving off or use the ath5k ca=
rd that I also own.

You could also ask Ivo to disable power saving for rt61pci.

johannes

--=-qUjUA8bTeDAgxxMmAVJ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbg7VAAoJEODzc/N7+Qma9qsQAJzeceoKb+CcNJ5M2tWeXCtu
eV3YNHugcgn4DdIgNh4OhnxlZ/dxhVljD+mzFyIOJSnxZ/MLaEoW4GYIRbtB/jP0
h43rWm4XJRaA3R7dQscDV2bly2GJ7YR0ExMTlRaZa2BpMGNglN2tj1acvgDlXzix
q9Cd71oFP8JU+qo3Ji7WKamOenmYi1LFUMPMVhZI0UTaiMwUjk7I7OeAx8hS/cQ+
IWPDk6rGf5vAyGWEO6odGeMgrHlaQ9Qr5haRdSe4YsgFEQMDhwoi0ugsNywmBVc4
cbl7SoZzzqwth3tRX0OPusjxY1j/53fLoSdAjW0Y5NlTVWy71iB2cQNa7nPw50GE
SAKkzYN8AZkFsQFDRJW7Dn9SOTYvJ3trDUo4r1WRNdB4Am9hZ3mNa8pL4+tf6aGc
iKClrH5545H62D00djoWsYug/XiYI0dzUpxdjXGTTfA8JPZkx4EpWSmcE9rjv5Vc
Nld8kDFU5xBBGW3LWTiblYPihwDme08weiZUeA+PgOosJRleST81GLPetTmKMHAG
ZnDQd7ObV+SUuR9QKCCQxV2MJZhkRGLIIcd5Su0w3l88RCCavI6gfTlycuYq8sL4
x1/56s8nEMnUQENaryZ9/OVEyY4Vd7ml36MXarOv8kphKyNMnbCFkt9MpwRXrZwd
Q+TjE5Qv9yKDCohLPYPw
=6Jqf
-----END PGP SIGNATURE-----

--=-qUjUA8bTeDAgxxMmAVJ0--

