Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbZFBUEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 16:04:41 -0400
Subject: Re: [RFT 3/3] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200906021641.11019.mb@bu3sch.de>
References: <20090602111027.460530075@sipsolutions.net>
	 <20090602111112.460472915@sipsolutions.net>
	 <200906021641.11019.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8qB5X9cbph+Fd1QEjAW+"
Date: Tue, 02 Jun 2009 22:04:39 +0200
Message-Id: <1243973079.6461.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8qB5X9cbph+Fd1QEjAW+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 16:41 +0200, Michael Buesch wrote:

> > --- wireless-testing.orig/drivers/net/wireless/b43/Kconfig	2009-06-02 1=
2:53:36.000000000 +0200
> > +++ wireless-testing/drivers/net/wireless/b43/Kconfig	2009-06-02 12:56:=
11.000000000 +0200
> > @@ -98,13 +98,6 @@ config B43_LEDS
> >  	depends on B43 && MAC80211_LEDS && (LEDS_CLASS =3D y || LEDS_CLASS =
=3D B43)
> >  	default y
> > =20
> > -# This config option automatically enables b43 RFKILL support,
> > -# if it's possible.
> > -config B43_RFKILL
> > -	bool
> > -	depends on B43 && (RFKILL =3D y || RFKILL =3D B43)
> > -	default y
>=20
> Don't you need to add a new "depends on" to "B43", if you remove this?
> Or is rfkill always compiled in if wireless is present?

Well, rfkill isn't always present but the APIs are always present.

johannes

--=-8qB5X9cbph+Fd1QEjAW+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJYXTAAoJEODzc/N7+QmaXaoP/iCYYAxc//tySXdewmpwFGHF
uU4wbZjecpRgybeiuVvm6tRPe5Wh3o+XbLqXFB/qZ/Cm78wcu4SZQtPjm+aXOSj/
GKs1/AYkCTkQp2sIuHC2HgcyUtnUlrWI+QoLDcvERzsWSlpOpy9vfZMUjvg4FDHC
b5Ee/8IBC0DG137rh70c7ws8SMimIU3kNyg193J1ZFCpOODMSyvYhBIEf1EGjF+U
3Ram4kTAFDm1teYKIOjRwlmoDlBvXZN089O7k7RkWo0xoizEMROLS18FT1nx0ecS
rVXaJhovEUXc2B2iHrsRE+PURCJ+etHkDgjlkdAzVzeNBYdtUnOk1AxWqF6aY84t
3TUw/M88rOyuYK7oFHPMxF4+Bp8wRyOXt6NQEWiRG4wpbL2LMzsuz7U71Cryg3ky
Bwiwbtz61P8sHl0QKCJKpAC9qFH77yGkhYOKcirJ1yEgUh4PHepv/5GLNkA61QRM
2nNoFPgIAF3mKXkcJN23o0wkrEH7fPaWJoTkP79/x72maOoMCwMELrDSAIdPq1WZ
XWImJIzrlPmZuHqZxpHAJSZuhu62h4B5oblTyHutGxYV2CIM4Q02d0mkTDxLg9e7
PFEBciKQJ22zuvEqOPOPGay+XUsxEHDOpePF0p+egVB+oCO573GxxXF7CyTHIGiZ
9OqY4JhdMdHPvCPTR8BZ
=eAkm
-----END PGP SIGNATURE-----

--=-8qB5X9cbph+Fd1QEjAW+--

