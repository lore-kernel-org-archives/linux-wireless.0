Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbZGWSOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 14:14:20 -0400
Subject: Re: rfkill blocking is sticky on virtual instances
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: tim.gardner@canonical.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248372692.28545.127.camel@violet>
References: <4A687AAB.8070306@canonical.com>
	 <4A68982E.2070101@canonical.com>  <1248372692.28545.127.camel@violet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aHcjddFlaDDMiOq4rhJ7"
Date: Thu, 23 Jul 2009 20:13:49 +0200
Message-Id: <1248372829.1218.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aHcjddFlaDDMiOq4rhJ7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 20:11 +0200, Marcel Holtmann wrote:

> > Tim Gardner (3):
> >       Added a utility function to acquire a list of events.
> >       Added rfkill_block_all()
> >       Added support for block/unblock wireless types.
>=20
> do you mind sending the actual patches. I like to review them.

I already merged them, reverted the first, and made it use the
CHANGE_ALL functionality.

johannes

--=-aHcjddFlaDDMiOq4rhJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaKhaAAoJEODzc/N7+QmaHg8P/2a18N3o2is1+64476sYtiqb
Jf3zo4fOp2rSDoLwXr9C20qoIzTdDRJK4qTRC0zV9U4oIEeES0d+/1JjQ8xvUEzy
3yWAg/7O8Zorvs1n57FLsxbhIPTDlzH7nLrFPWtu9sqUyiJLreeJdBGAdE5nI0ie
Tb8yowPKHRd1pf4As5n5u1OS2/sk6y76MsMzeq7xWCltI5q5b116mCazW6ZDRFOW
c2whsEG5F2XquKWdeEHAzxcv9SYQRH7RMtR8LFuCmGJ1qgQ5QCGKCQnlXn87QTL1
CaR/D+IumY0ImeTbs+HFmsh85LmpVfe2PYePGes2gS8t2a2kHc7znpnSwddG1u30
Lw7kobI3kpSUdkyJk2IZdvkv73ZRGshFgvgX3z7/KwGL52y4Iq+xjyywNIarcawL
QxKbwtzLElbmHJ/HXIm2p26FpL1L9yufQY1NxEmd+F8V+lP5F8OJFR4kvqehbZ7B
k2xOrT2LAM/uT3wZR1pB0TJPTaoPd8LcKzKKBVtj8jPS8ITb3Nb4M54OhHq6+pLl
8eXtTOvzFLAUg0UZTOdkDo45RAGSptUB+tKV9zrLaV9eflDkvEpGiOGUzV7Z52tp
Xui8Gq24ygofX4RFlJTJBl9OyJ6UwWoZrOXw3urNA2Rgp+IDuufVebqA8qRH/VvV
llfvRT6s2cVByR8nW8WK
=yS6u
-----END PGP SIGNATURE-----

--=-aHcjddFlaDDMiOq4rhJ7--

