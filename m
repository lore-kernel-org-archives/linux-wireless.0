Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48896 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbZKIMyY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:54:24 -0500
Subject: Re: Incorrect signal levels reported using wpa_supplicant's
 driver_nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Sack <asac@ubuntu.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	networkmanager-list <networkmanager-list@gnome.org>
In-Reply-To: <20091109125016.GK1579@jwsdot.com>
References: <1256953837.9681.13.camel@maxim-laptop>
	 <1257190833.1027.4.camel@localhost.localdomain>
	 <20091109125016.GK1579@jwsdot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eh0g0kTNSMztQlSA6Ip6"
Date: Mon, 09 Nov 2009 13:54:21 +0100
Message-ID: <1257771261.29454.169.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eh0g0kTNSMztQlSA6Ip6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 13:50 +0100, Alexander Sack wrote:

> > Soon.  We've got some patches for this, but we'll also need tons of
> > testing.  The WEXT stuff is pretty baked while nl80211 is still under
> > some flux.  But of course the only way we bake nl80211 is by switching
> > to it...
>=20
> iirc, we currently we hardcode wext in NM code. How about adding a keyfil=
e
> config that users could use to switch to nl80211 until we feel confident
> that it's good enough for everyone?

commit d27df100b587dd95f3256a8baf9db0c5d4380089 in wpa_supplicant allows
you to do that by editing the service file.

johannes

--=-eh0g0kTNSMztQlSA6Ip6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+BD5AAoJEODzc/N7+Qmah3MQAL0v03JFGWYZLvVczDUtyZMq
7A1dFF5cGD112HOB8LvbcbtcsIC+HVNM9XBDqJOstIil+EP3e3mRirclC3rqtZUy
Sjyhrau8Lh7WVjDffZP+TBeWv8ts0o/EEj0heFcDdemK37UTNYpxg2SM15FfBy2d
X8xwixaN2TMjiYwz7RPqsWvFE1QnbPrGkblnE+ouWHqDr7rJkrDr205HUsAO7Qlb
G7CfN8vBDv45IgLrwruOXXtTAmeEgM7U0PWv5m4NlJHMnk1bNBrwzyBpdcUzEfsR
BtdFGZL/RV9cIiKHj2nhNeyCqFKf3MQe4ULmxShO7fMLVqXr8/J/1IHzki7fkLow
d61isOlCA7wZwIpddyOtwEdi2OqkdBJjDywEie6Y8aF2TIKvRegbU+9ety2IqNIy
vrBmde3Bwo1rYdSCdFCnqrYh7VZC1fJbIsAQBskKacYjzGA50rtT60fzW2FOvOoA
gjt8g/GM9ia6QaHS9tmOuvdcLUcaUELV0/mqSjl8oGxYZ7CUU7y1odQZFaLYR8DZ
z4tPMFtIhgnx3uyNsxpAToILuxpvedy47d7KtFsxQ/7P0qowZItqPcZ5Wl9Q15lf
wXKIn85A2aaiV+u3EJ+XegkYo1+gXQaDqMSGw6PUk5ARn6NETg/mbCcGygGw5gSO
gBLjg3fNd2QLKgOnCWiy
=8oqU
-----END PGP SIGNATURE-----

--=-eh0g0kTNSMztQlSA6Ip6--

