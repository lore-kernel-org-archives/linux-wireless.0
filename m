Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYKMC0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 21:26:14 -0500
Subject: Re: [otus-devel] [FYI] ar9170 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890811121824h70cdaci9eefe4fd625aafc9@mail.gmail.com> (sfid-20081113_032437_472231_5F43E061)
References: <1226531034.14186.39.camel@johannes.berg>
	 <1226531788.14186.41.camel@johannes.berg>
	 <1226537117.14186.44.camel@johannes.berg>
	 <1226540559.14186.56.camel@johannes.berg>
	 <43e72e890811121824h70cdaci9eefe4fd625aafc9@mail.gmail.com>
	 (sfid-20081113_032437_472231_5F43E061)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vK3gGVrixaCLdD/RZ7Ml"
Date: Thu, 13 Nov 2008 03:25:47 +0100
Message-Id: <1226543147.14186.75.camel@johannes.berg> (sfid-20081113_032617_295939_F929ADC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vK3gGVrixaCLdD/RZ7Ml
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-12 at 18:24 -0800, Luis R. Rodriguez wrote:
> On Wed, Nov 12, 2008 at 5:42 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2008-11-13 at 01:45 +0100, Johannes Berg wrote:
> >
> >> Better URL is
> >> http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-ar9170.=
patch
> >
> > In addition to that, you will want to apply this patch
> > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-mac80211=
-fix-tasklet.patch
> > too because otherwise sometimes mac80211 will schedule a disabled
> > tasklet with the expected dead loop consequence, and then later will
> > even wait for it to finish... I'll submit this proper once I've figured
> > out why it's happening.
>=20
> I get a 404 on the second patch.

Looks like the magic with NNN isn't working right yet...
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/007-mac80211-fix=
-tasklet.patch

johannes

--=-vK3gGVrixaCLdD/RZ7Ml
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJG5AoAAoJEKVg1VMiehFYB/8P/RY7laxwWBAH14L7JP0cD1yF
Y5891xBT41yI6iHof/uq4xjGpgGih3QT6YVbQqYYjnq/rhCb9IHSnQRHM4j5MBYL
YkPfzbH3EsTS2RTRpl3CiRhmzGgEH7Ds8gWmF3RgCcRPMCkmluFbKjACT2M0wQSZ
y863zTEy6T4AHj+bjjE/hWOgadBKRJKHbHOCBciyQHdlrji2Vy3j+pX0xhJUIlU6
Y0jY21dZhX5qGGpmsLSGOqIQDDEcpOObvFiYJ8ULMqcdN4EnQSdhGAKMBhPO5oPM
LNa34G/8jZcKlowOAxZVPFtlvtAlXxpWbhrYlkXsLLzvP2U1NNzq5cVmtcmV7hXi
V+RlFImm9hH+ZOTpOjKjnE8CFY+jLxEz7QosKIAmdYGI+XqX+7C9Oq94CQKb5oce
v7klr/hq8jvBBt7wWPizK6qit9l3jDXbAckXNd00a/4N8JZ6D0wgUiwmBBi+sv4v
ck5qKphQJVKvsfiZGNo+3zyvXRl9nA8wgx6rOIoJnO818gc9Phncm5bjSzIouJjv
gxftdUxRGyEH0+QcBTMk6STa7EaSAsZxugh6qOtsRmBTqxQXDhPPSZJfykMv6QXU
7R6LIhYtligEcQ498txpPgPuLzpJZxzZDRUEU3OFIwM87dIUrhm05fCQn/TKhg0v
durE6dn/m9gsjsSzb4rn
=Yxc2
-----END PGP SIGNATURE-----

--=-vK3gGVrixaCLdD/RZ7Ml--

