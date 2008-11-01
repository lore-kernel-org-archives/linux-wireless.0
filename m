Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYKAOcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 10:32:41 -0400
Subject: Re: [PATCH] mac80211: Allow AP mode to be enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <871vxvmsnd.fsf@nokia.com>
References: <20081030175030.GD3923@jm.kir.nu> <878ws3ptrh.fsf@nokia.com>
	 <20081101114754.GY3923@jm.kir.nu>  <871vxvmsnd.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6FswuUXHayTxqk1UH5m5"
Date: Sat, 01 Nov 2008 15:32:34 +0100
Message-Id: <1225549954.3619.4.camel@johannes.berg> (sfid-20081101_153244_296136_8C9EE466)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6FswuUXHayTxqk1UH5m5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 16:23 +0200, Kalle Valo wrote:
> Jouni Malinen <j@w1.fi> writes:
>=20
> > On Sat, Nov 01, 2008 at 01:31:30PM +0200, Kalle Valo wrote:
> >
> >> I tried to test this with latest hostapd (commit b6a55236) and
> >> wireless-testing (commit d80fe0040), but unfortunately I wasn't
> >> succesful. Here's the output from hostapd with b43:
> >
> >> ioctl[SIOCSIWESSID]: Operation not supported
> >> len=3D4
> >> Could not set SSID for kernel driver
> >
> > Thanks for reporting this. I fixed it now in hostap.git. Johannes
> > removed SSID configuration from AP mode and I was just waiting for this
> > to hit wireless-testing before committing the change into hostapd.
>=20
> Thanks a lot, I updated to hostap commit 4aac554c and it works now
> with b43. I was able to associate with N810 and ping worked. Even PSM
> seems to work, but I haven't made any power consumption measurements
> yet.

I'd be interested in power consumption measurements, but it should work
fine. There might be a slight bug in b43 wrt. the beacon timestamp
offset though.

> I'm very happy now, thank you Johannes and Jouni! :D

:)

johannes

--=-6FswuUXHayTxqk1UH5m5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDGh+AAoJEKVg1VMiehFYwCUP/1faEZINvbrdU+W59BCZcvuo
jbljvCORMiwOYFEACqRv8rXBFBOu8InEr6R6dP1+XaJ2vfnOILa/w/fjqgYh/iDI
Gjap8ekI46jOjxTAnwtEEnk1FNmjepp0JGNbeISTIRphBYM8p+g/rpwyijw2+LWg
ZFNWvMBxH9whNWotNn2PWbl9zf7FjhenzjPbcxFbgMa/97q949GqaOIxmZ5a5JsI
rftEcHg+2KikKmV0BFyaPagUfGT6LjnBcDLufSxL+Ym9i5dcqsxROCp8rjLfquqt
fP6n1ucgOsJJeC0BqIgaPdUZhiy2crs2fthRTBvZHo5vgf3aIF7CJyKBIoH7lnbU
G22AL6etYjVG+QxnXLPYy46PBEITV6Qg9pomOFVYJppBNkqvolx3PmkZY1z/hYrr
XUCs0hIl5Wp/Y9OxpIwsutqFtQoipsyBBgSUGIBzakgETwb7sm+S65HIoscMUEtQ
A/0TO8W7fzI2oenLtbaR0lH8rLxYZ5uK2I3sOhf7JUrPC3LgiSyHXxqyaOHvGBRi
onsrbjm2uSHoh8UZQHxK/8R3Gl64aKQoKwN0vCCU20ibVm/yOS2/DjEDYJXIG1MQ
RIKhIPVShYVcIp7mLJcH2WmZAF6QvxaWlz0eQPBdf3nLdxyXRfu9oaE0J10FqDqL
cAiIZDDr/DgCBFrFspJH
=Y+OH
-----END PGP SIGNATURE-----

--=-6FswuUXHayTxqk1UH5m5--

