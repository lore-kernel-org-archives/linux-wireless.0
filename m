Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbXFNJGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 05:06:05 -0400
Subject: libertas (private) ioctls vs. nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fIKcpBjZcnp/swqiKO7e"
Date: Wed, 13 Jun 2007 19:58:02 +0200
Message-Id: <1181757483.29767.99.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fIKcpBjZcnp/swqiKO7e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

With the recent activity around cfg/nl80211 I was wondering if the
libertas people could offer some input on what configuration 802.11s
requires, or even could start specifying some preliminary nl80211
commands for 802.11s.

The reason I'm saying this is that I'd really like to see a full-mac
driver use cfg80211 unlike softmac drivers where only mac80211 is
involved, just to try out the APIs a bit more. And libertas seemed to be
a suitable candidate to me... Maybe some other driver would be better? I
personally have no full-mac hardware available nor much time/interested
right now but I'm sure some form of full-mac hardware could be made
available to interested hackers.

johannes

--=-fIKcpBjZcnp/swqiKO7e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGcDAq/ETPhpq3jKURAurIAKCB2uxH+RzNvhOdPjjuVz9/XectGwCfYPwQ
He4gHSOx9yxoRZ0rCP6lHio=
=lFZz
-----END PGP SIGNATURE-----

--=-fIKcpBjZcnp/swqiKO7e--

