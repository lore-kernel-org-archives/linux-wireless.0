Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbZDCTXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 15:23:05 -0400
Subject: Re: How does rfkill work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238771745.5347.17.camel@dax.rpnet.com>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local>  <49D5018E.6050001@lwfinger.net>
	 <1238696913.6137.4.camel@johannes.local>
	 <1238771745.5347.17.camel@dax.rpnet.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OPSutcPKEd23GAPKcrQK"
Date: Fri, 03 Apr 2009 21:22:53 +0200
Message-Id: <1238786573.11352.0.camel@johannes.local> (sfid-20090403_212310_151052_0E754AE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OPSutcPKEd23GAPKcrQK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-03 at 16:15 +0100, Richard Purdie wrote:

> > The trigger's name, should be
> > 	led_trigger.name =3D <something that is NULL> ? : dev_name(&some_dev)
> >=20
> > Does this make any sense to you?
>=20
> No, it doesn't make any sense and the 'fix' he posted isn't valid, just
> a workaround that happens to help. I suspect there is memory corruption
> going on somewhere...

That's what I suspected, thanks.

johannes

--=-OPSutcPKEd23GAPKcrQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1mIKAAoJEKVg1VMiehFYWyQP/iWeURf+Tg6j6tpyL3YV6Oex
PJC4YdcfgKMrhIDYMAJWCDrBBJsbQHciXwrJsQsmqcEDEgP3p+2b2WHp66s4ktcr
STRcJHMBK370il1vYt57VgZ7J/DVV01+frLTwDr5CsLY4HyFPaOPlEFjNOFY58F+
/dTtlTFTVeL4LOfwvrnYEer6nXJ8DV1rnrWx2yQoPSHNn7k0vVFITk5FzORpaLEN
AJa/RDtcYdQNtCPG9NBy+EByUy5SdVtMk9VhtWuQbCSGQUHEFr/k91jSU956q47e
yikuY+m36Drxpln6A/CDA0Rm809UKISwwM6b2yjj215omcUyNFgzQIB3uHUzSusm
EdxjcWAUz3OKf+LtuHZHr0H7K//C1qn130QBLtu74wVMU/Ck5w2S4xKzAgkzK1VU
TLdIqSnfPRg1KuBV83oaJTcrkI3ZRyzweyiH15Yzq5RQdeyfdnzj52CeWGEkQ+cX
4lR7x5fKUmXGIxl20BS7VygU3fL5TkGkQrMCLaN74grEOB7i/oeeht3sgANH6nD0
TQfotPN5FGBDNu+SOn5jEvJs6klmrZztZTbQtkE0bzIIKfQYNEUU108qFgrHtYj6
eQD8txrU81au0hxpW48e1plA8LcqucgPEiLTYCRM9fMHqgDnpOuAMFHLa0jLnOLo
PGlTNd2IcGKV7igfcl+Q
=t85w
-----END PGP SIGNATURE-----

--=-OPSutcPKEd23GAPKcrQK--

