Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbYCALJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 06:09:44 -0500
Subject: Re: [RFC] p54: spi driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Kalle Valo <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Steffen Meyer <mey@iis.fraunhofer.de>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1204297442.3938.26.camel@johannes.berg> (sfid-20080229_155335_777774_BB3F5232)
References: <1204297442.3938.26.camel@johannes.berg>
	 (sfid-20080229_155335_777774_BB3F5232)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aC58N9yKmWWhUAOWLqSG"
Date: Sat, 01 Mar 2008 12:09:30 +0100
Message-Id: <1204369770.3938.82.camel@johannes.berg> (sfid-20080301_110947_962245_8F776293)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aC58N9yKmWWhUAOWLqSG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> To build mac80211, I modified compat (patch in separate mail)

patch merged.

> to make it work with 2.6.21 (and not try to build PCI drivers
> all the time!), the resulting modules can be loaded fine on
> my N810 and seem to work. In order to load mac80211 you need
> to have crypto support in the kernel. That isn't enabled in
> the default N810 kernel (sigh), but I managed to build the
> crypto code as an out of tree module in a way that in-kernel
> code assumes crypto is not present while modules can use it
> fine. I guess I should add an "N810" category to my homepage
> and write about all this there.

http://johannes.sipsolutions.net/N810

johannes

--=-aC58N9yKmWWhUAOWLqSG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8k5aaVg1VMiehFYAQL65hAArI31ID/McBidmlgviy6IyrYmt7ooQ/ym
lTSD6PEboMZtplveeIabsuRasl0AsBf4qGiVgD8SOWuM6oXS5md0cM2mOd2zAxIk
lN2/q73ZsMITqPrNjgpByeI6cC06nwjhuxtATMk9Z2mCjosxmA2r+DjQDC32pLjN
UYwwb5ILbuaXA99D4pMhoV/ct0do6vewoznbpRWb0qNyidZDeJ3UVhFaIO1vi9at
B0TmRFVoY/Pwe+whU9IDqKP330NDFJVlypYRlqF5YACl1tUXdnNW+r6EeHvhaH3v
2i4zOKW5QN3ym6ZAi0GdCWflJz2PlETJ+sMcvdeVmEUObapsJLi+rVhu2ie7z53Z
3n5KFg7WnbDCUmfs3mHM3saF+hwczlPc961WoLtzEg6gFNqr2l3bu6BOEHv563KE
Azv6kZ60mP8I6jphtdeO5QiIFXjQepbxfZ0ipl5H69E2Rpl4e2SK9OjL5PP7owCw
7SPmkx1kBs2oYIxO0s9dOy5ry5YIEJc5zMI+To2aEWqIkfwIUuZxLkc8hkG5Ig+S
W/DIVlmpYO/pc7QA8YveHtU3vGDPJ99DbmxaOzWWg9hGxiJjff/Hz8G99a+2sZ6w
uCZtNZLG/zbl08om5joCvaOpQfB5pHJRVxAvsYBJjBqm9vIE0mmPt82thxi6iLZw
EYbJUnIzs4U=
=QMfM
-----END PGP SIGNATURE-----

--=-aC58N9yKmWWhUAOWLqSG--

