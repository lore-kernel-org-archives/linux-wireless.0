Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYJWPAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 11:00:55 -0400
Subject: Re: [PATCH v3] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, Luis.Rodriguez@atheros.com,
	Jouni.Malinen@atheros.com, tomasw@gmail.com,
	Sujith <Sujith.Manoharan@atheros.com>
In-Reply-To: <20081023145102.GA5816@tuxdriver.com>
References: <18685.37489.577735.596008@gargle.gargle.HOWL>
	 <43e72e890810222010w215b278bya788e0c94250b517@mail.gmail.com>
	 <20081023145102.GA5816@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-26CpvHQxE5Ps3u76twPM"
Date: Thu, 23 Oct 2008 17:00:13 +0200
Message-Id: <1224774013.6002.40.camel@johannes.berg> (sfid-20081023_170105_430552_7FAEF3F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-26CpvHQxE5Ps3u76twPM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 10:55 -0400, John W. Linville wrote:
> On Wed, Oct 22, 2008 at 08:10:42PM -0700, Luis R. Rodriguez wrote:
> > On Tue, Oct 21, 2008 at 1:27 AM, Sujith <Sujith.Manoharan@atheros.com> =
wrote:
> > > Wireless HW without any dedicated queues for aggregation
> > > do not need the ampdu_queues mechanism present right now
> > > in mac80211. Since mac80211 is still incomplete wrt TX MQ
> > > changes, do not allow aggregation sessions for drivers that
> > > set ampdu_queues.
> > >
> > > This is only an interim hack until Intel fixes the requeue issue.
> > >
> > > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > > Signed-off-by: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
> >=20
> > Poke.
>=20
> Just waiting to see comments from those who understand aggregation
> better than I do...

Who does? Code looks fine to me, but obviously it doesn't really solve
the problem, just adds workarounds for the current ath9k driver. Whether
you want that or not I'll leave up to you.

johannes

--=-26CpvHQxE5Ps3u76twPM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAJF5AAoJEKVg1VMiehFYnAQQAJ7Y6SDNExUNRlwzZCo2+8w2
/uEWWKnqlJt6iW+sOkwZ4xNlN9yLePGvyMZE7XKAXDf9wPMoPqAXCA2M3tf/o4ex
qhRDmTYE1hfApOVAlM1E7idGcJIQ+KUGKbjjpnkSVP8WfREv2ZLYN6+Fy2nyYNxZ
6rSBUXg9MXq7RYvDNPciDSY4wfOkm7xIIs1YLcyaXJpA2rQln1rPhwrf+92K2lrZ
Hfyu4Skmzz/4EYtNklEa7/AjgM5ZsfNnerqmca0XkJEZ4D2CGGjHu2iA32dwo3mf
oxx0TL70IH3eV5ZVTA4VccHYn6ZbsmAuCLWWpIc6NYPs9iqOgkHQAxKZohGVIKuJ
U0RYO0CT7W1h1SE9uXTKUu1W38OpDi1vlAo1G6hWVVom/2Dr23WFVdaCfMHbE/ib
o0RA2PFAtwhjTiFPnlCYdpN9BBRe7mdbzdbrFFGZIc6ofSJG6khMKmmjwuu7/I/d
01atChhe0GARu3gpXr24zXyFv/rAe7RWOrxmhE0OtQu9pC3FoT0R4OdXBucFlDuU
1jmneUZpIPwFpDC7jgoCWWFTn5V9EkTiFKtSQeotM3gb4+U3xHBcZUZCuAJsrT2K
eQTFkoF9LHogWpuwYAqAxiKPfOYBMYaGKvcFlyoLjk7lMmEd+dI+ukmPj/kyZEY9
xkD5hs7Z/sCFj9cKf7CN
=rW7B
-----END PGP SIGNATURE-----

--=-26CpvHQxE5Ps3u76twPM--

