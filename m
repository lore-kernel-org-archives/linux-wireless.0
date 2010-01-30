Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0A3RPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 12:15:32 -0500
Subject: Re: Multiple SSID on same phy
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Greg Oliver <oliver.greg@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B6465F4.1080901@openwrt.org>
References: <20100129122718.73a6c877@nehalam>
	 <1264866128.3546.185.camel@johannes.local>
	 <51058d551001300751r4a509e90i521c946dfe9dec4@mail.gmail.com>
	 <1264867217.3546.186.camel@johannes.local>
	 <51058d551001300814y66d1d589uae15fa50086593b8@mail.gmail.com>
	 <1264868231.3546.188.camel@johannes.local>
	 <51058d551001300822p7ab564e4jedd6faad380dabc@mail.gmail.com>
	 <1264868803.3546.189.camel@johannes.local>  <4B6465F4.1080901@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ih51bXuNE+9T+M50f5rp"
Date: Sat, 30 Jan 2010 18:15:29 +0100
Message-ID: <1264871729.3546.197.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ih51bXuNE+9T+M50f5rp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-30 at 18:01 +0100, Felix Fietkau wrote:
> On 2010-01-30 5:26 PM, Johannes Berg wrote:
> > On Sat, 2010-01-30 at 10:22 -0600, Greg Oliver wrote:
> >=20
> >> > I don't think I can parse that. In any case, a possible use case wou=
ld
> >> > for instance be a protected company network, along with an unprotect=
ed,
> >> > internet-only guest network.
> >>=20
> >>=20
> >> Hmmm, I would put the odds at that happening about 100,000:1 (if not m=
ore)
> >>=20
> >> Yes, I know it is feasible, but HIGHLY unlikely.
> >=20
> > It's not. openwrt for example has that as a default configuration. Even
> > fonera does.
> OpenWrt doesn't even bring up wifi in the default config. It has a one
> configured AP mode interface per PHY, which is disabled by default ;)

Oh, whatever, but it's a pretty standard setup for it anyway.

johannes

--=-Ih51bXuNE+9T+M50f5rp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLZGktAAoJEODzc/N7+QmaFHYQANOnnqL/IbnkNtoOiF7cp79S
PDqnmnUxMt2xOmFwSCrl7/qJ4WjU8mLGMQfxVT609n10vmmuQ6IIMoZ6qaUVgI8t
lPbUAWXkckXbJsKVPN349P3T1yi9XKRwR6ehE9h/OQIl/jUcVUdLfO1xmhJBRUUl
To5tbH8as6/heyO7H3L9YTzaqo/hZWDI6eCPfZL52pdDv0sQrK9ldkcM/wXc+L2Y
+F6CMvvyOIL6Gw8NVYQbsTLsCeK7NWQgZDXu8EPawX6QrfRlZC3P4VIp4UWFrTBY
hdt3Y6+AVd0EgCq8Mn0o3w6YLVSrXu7V4P0Hin5C4nc5N79Vr/EZIR0K11F/Rw0l
6PLkqJUG/yflaIjRPFqJV6mHbw9i9IfvjJqmgMFyAJSdmrUd+VAaUubwzJgX4ocA
4Mc6JolPWWBR62kxAKIIG257rgv1JEAer/Jqq6UzCWwqXBv13NsBzMwK1z6z0B4g
ivbedZlVj88ulCoQNgYSJ+WvnlhoVqhdlQJMY5SqVP4SS0Yr8kjFnZd65bvRfXpG
I7+AVaS5NUPP3bMIsbsqn4abrOgMX7dkICKoBb3D5KzvB4mXgWL9oSbJkywEMo//
cHnrwoqHGO5H7CLmEGc7ymPi1y5GS8PwKhoVqGH3j+9ZNLMOUKDT+dJp5C3PfCDO
Z1xpHu5bVSrmD63a7eTb
=V4oP
-----END PGP SIGNATURE-----

--=-Ih51bXuNE+9T+M50f5rp--

