Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48701 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761623AbYHDTRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 15:17:19 -0400
Subject: Re: one remaining unused CONFIG variable under net/
From: Johannes Berg <johannes@sipsolutions.net>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0808041508070.11910@localhost.localdomain> (sfid-20080804_211117_795474_92E803F8)
References: <alpine.LFD.1.10.0808041508070.11910@localhost.localdomain>
	 (sfid-20080804_211117_795474_92E803F8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/e7dBk1m3zvfSaNztmTb"
Date: Mon, 04 Aug 2008 21:16:34 +0200
Message-Id: <1217877394.3603.5.camel@johannes.berg> (sfid-20080804_211727_204025_E42EB4A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/e7dBk1m3zvfSaNztmTb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 15:09 -0400, Robert P. J. Day wrote:
> this is the single remaining CONFIG variable under the net/
> directory that is currently unreferenced.
>=20
> =3D=3D=3D=3D=3D MAC80211_VERBOSE_SPECT_MGMT_DEBUG
> net/mac80211/Kconfig:206:config MAC80211_VERBOSE_SPECT_MGMT_DEBUG

Yeah, it'll be used though; it was added in an early patch of the
spectrum management code, then that got delayed by some confusion over a
requisite patch and now Tomas wants to redraw that one too... Don't
worry about it, I'll be keeping an eye on it.

johannes

--=-/e7dBk1m3zvfSaNztmTb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIl1WOAAoJEKVg1VMiehFYVuUP/0LOPy0HeDFjHfBY01A/ilsb
wA4esl7P3PLaYqNoz8kcOYSgCe78bta64GXFyHz3aAJ9pwoF5srWYqlYMxn0UUlX
KSRQMShi4IMFRzx82iKp+Ffg5SISIA7zo48VCZmjWyMeLWKs1OOmj5XOByFKGPXZ
CmJTU7OFMeZsAkigONA6xbLKn8bwEGY73vtwS/3CvGpDYyE/ahruijxB+e0+4O3+
Tk689zoJYmofy70EUJlL/Nrygm3SwsfsIHYBTRKrq7TvyObHewXKRURUdv2QNGlJ
9YB/atIZSqZi1HN5BIN/wCR7YIqQbGTXD26kTGdy3yyRx9+9rmKxuKi0EPlvxeZ6
UhKJGKAua2GSYdWqPdLCcUo9w1hYEaAxOzdMFRVuN5MNI8lf5P2fpbJlsqTUHHRw
gRTw6n6VKIcRW747FM+/GZfpJtBCrPLh/1lutLUiBg/ig7WlYzQXgFh+1c5Hjhg+
qSa92AGlxn7kEKoNNPeDeNSjXMb13nYgADDfkhJAA1HORBwUlgD2jupzxUiX+JAA
UrdIhIrpx/t6Kz0yT+IdTjF4jJpkUMWWTNvBj0Tx5THiyIiS/Yd27o0K55OcDHoD
YdVjbRkVT2RmWReLKZRu+/L/Vdi6l2ITAwaC3v2sI8QicYY+V6zW9dzFYiToTdMs
yUg978f5LJKLp8xdkexq
=PtJ0
-----END PGP SIGNATURE-----

--=-/e7dBk1m3zvfSaNztmTb--

