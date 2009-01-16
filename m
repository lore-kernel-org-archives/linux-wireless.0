Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZAPUiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 15:38:54 -0500
Subject: Re: [PATCH 02/13] cfg80211: add option for wiphys to disregard
	country IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090116164004.GH29609@tesla>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232097432.3854.15.camel@johannes>  <20090116164004.GH29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DYDwE8r5aTDfbchU6Rms"
Date: Fri, 16 Jan 2009 21:38:48 +0100
Message-Id: <1232138328.3745.13.camel@johannes> (sfid-20090116_213900_832997_767732FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DYDwE8r5aTDfbchU6Rms
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-16 at 08:40 -0800, Luis R. Rodriguez wrote:
> On Fri, Jan 16, 2009 at 01:17:12AM -0800, Johannes Berg wrote:
> > On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> > > Country IEs can be disregarded based on regulatory policy by
> > > a driver. This is only possible, of course, if the driver already
> > > has its own regulatory domain.
> >=20
> > Can you say why? This doesn't seem useful to me.
>=20
> Its based on our internal regulatory policy for our hardware. If you have
> a alpha2 map you should disregard the country IE. If you have a world reg=
dom
> you can follow the IE (but not enable more). Technically I think that wit=
hout
> this things may work now to respect the original driver stuff though with=
 the
> new orig_* changes, will need to test.

I think it should work w/o this, yeah, and I also think we should follow
the 11d hint if it restricts us further rather than just ignoring it.

johannes

--=-DYDwE8r5aTDfbchU6Rms
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcPBVAAoJEKVg1VMiehFYQT0P/0iu9g/7uezEPVwD2DtlsYH+
6cwyBM144r1GRxkIqHGoewkt5mk7b7hVWo5CHFGBSJ+5dOp5aDoO93qyQoN6JWSd
QpEKsbWIgrEhbU6cMZEBCO9Br+1Tb8+qFGSGeAtfwpOTxCfRwkMM2fiG1fOc+B5D
PnexUoeZjBfPZQOi7OmwlDuNuqAL2+266Kcq+qcaQEWvNSEk3IlDgMPNb+A7x7BB
IWl07ov2SWnfTCHHcieA75fT7jh9cecx+LY1NpJUz5H9zhF1cN184seM9iM9zt21
Ih2xmE31qGT9gFw1MA2FURXy+EjqzRozo9Pi43AFYaFOezncqMaTjtUwRTu3b1vq
VbEM82e7MK1yl3t19duUkk5WhlwavUCQE2BT51RJv6tOfZA3M5LArI4d9fnDPhsD
JYoZ5A103uE7/rPPmAMgVyTFyL/Fg76mpdV7d0yLEhwiYjS8sAyBlOTTl22L2FpD
B0Kyvc8wmJyFax9zyHY3Tk1rLynKyLythWWQDmUBX/n3Fp9iGps3fcwxNNHZlzRa
PZ0XdxaAmzdNgYLH6EpzCq4laNekeXG/Qkj0l5t6EQWI/SRwc+l5LV4EWL6caqcg
DPfMl0XusEWYukPpWTpLg7af4JrI7QZWmODAK3n1fXfdVYk22RK+9V9f3jvpVIBP
ZxC6/+CKz1JSNj8YoeJW
=l6Lr
-----END PGP SIGNATURE-----

--=-DYDwE8r5aTDfbchU6Rms--

