Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYKFMaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 07:30:04 -0500
Subject: Re: [PATCH/RFT] iwlagn: remove pointless TX frame check
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1224794532.6002.73.camel@johannes.berg> (sfid-20081024_114728_369906_13A28C41)
References: <1223547733.22490.43.camel@johannes.berg>
	 <1ba2fa240810091308r167b9147p46f74421329a55c1@mail.gmail.com>
	 (sfid-20081009_220831_876301_EA9D5BD1)  <1223630089.3930.71.camel@johannes.berg>
	 (sfid-20081010_111517_870111_CBA3F26D)  <1224794532.6002.73.camel@johannes.berg>
	 (sfid-20081024_114728_369906_13A28C41)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EVvnj8lLmr0E5R9045NN"
Date: Thu, 06 Nov 2008 13:30:03 +0100
Message-Id: <1225974603.3619.219.camel@johannes.berg> (sfid-20081106_133010_464300_7B62BBBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EVvnj8lLmr0E5R9045NN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 22:42 +0200, Johannes Berg wrote:
> On Fri, 2008-10-10 at 11:14 +0200, Johannes Berg wrote:
>=20
> > > NACK, the completion of association of mac80211 and iwlagn isn't full=
y
> > > synchronized so there is still
> > > a race.
> >=20
> > Can we fix that?
>=20
> Ping? Any idea _where_ the two can get desynchronized?

Ping again. I like verifiable reasons for a "NACK".

johannes

--=-EVvnj8lLmr0E5R9045NN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEuNIAAoJEKVg1VMiehFYIMYP/1i9eHkIe3wD0flUxLRgPVrI
d8FzR+fYUW/kufmElN9wov6b+qne8WIOn+yUsQvi+i/BTGDiLHbFxpYaFtyNXTeA
QllPgair1IkN73Am9nRT1pokP2wxR5bqK9zv4bxKqIqY2UQWwlGUXAGZyHTCbFHl
TanN00ZAHf2IWy+UOgACvLeafAVBB89E3TsgqCiDZm68aozXVq8uds4iYWcD+Vwc
ChE1iRz058QQWG5+Oo4gYePJf4iOAWs/y0RHAg83K0CWOMQVcvW1xMN0J48blZbc
75cYG+Xi1XEuwxKQt6Y0jac0M9tNSRzfY/2yN4Yk4mfYJ4/HXD0UyYSBbPhqiXQy
zSj1YCHb472XzkZ8rAlqx+tQqd4Q4FbTIRayct76QTr5q8kOylFhxfI63n2awTH2
imOgZTz3+4y6vFXWR8m3FNuzUic9MbS4suJDxlhLly/vJDojupwnds4uKkIjLJYI
7eA9quVpVK264MAPudv+SsFl1kiDxWS6+Sc5B9MftOeGuJOifI05Rad7lTxkx7Eq
7K2KYe1GQ4CiAohWoz0CYnmPRWlYhGeN9ggM33mei5c+tcJIcK7CWe5WVygnbJXQ
NRuXdmSJK+zHCFFnlmxf8dpnPo6N7I/8JN3dhviq+Aj4cJzUdakhw9Y2XQXFa38y
M57OE4A284cyklBC1YSV
=29EL
-----END PGP SIGNATURE-----

--=-EVvnj8lLmr0E5R9045NN--

