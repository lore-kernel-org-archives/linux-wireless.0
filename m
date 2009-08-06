Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474AbZHFNJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 09:09:52 -0400
Subject: Re: [PATCH] cfg80211: fix disassociation warning due to misuse of
 wdev->current_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1249563308.15613.9.camel@ct>
References: <20090806085242.23637.82992.stgit@ct.roinet.com>
	 <1249549574.4852.17.camel@johannes.local>  <1249563308.15613.9.camel@ct>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TJUoit/MWpzM+al6r6fe"
Date: Thu, 06 Aug 2009 15:09:18 +0200
Message-Id: <1249564158.4852.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TJUoit/MWpzM+al6r6fe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-06 at 08:55 -0400, Pavel Roskin wrote:

> Now that the check is fixed, it turn out there is a related problem in
> the same function.  If the device is in the managed mode and disconnects
> from an AP due to a low signal,

Who decides to disconnect?

This isn't making any sense to me. Once you're connected,
wdev->auth_bsses[i] shouldn't be set any more.

johannes


--=-TJUoit/MWpzM+al6r6fe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKetX6AAoJEODzc/N7+QmaGnkP/03+SapbQR5EthKnN/slT2XI
nR8sM9hG63RtIOaefq8z/pMlnyQIu2cdu3B2Br3K3XX5yS6NP7nfnhqOfstMYNqS
u3QPEKbYraD3J3/58Jbqna4ny4Wi/+pTI2IKYIDDIybBtRd/BZUojgTJfKb/GvC+
fm29u9MSLS1+PXBtjZ2quSmgnD/JmXQ5v7qV2Uy4v0dc7UjhLj7hjT76lGzSfTVD
85oZXxZtZb/HR37cYXwp6GV4ereOcawavJ4nHSLuYyNgTEaTgLM9SNaYeAGzVWgu
siDCJjeG9BpTO4J92MgAHUes71NB2Gjj9Rkuo2qkqqVakdLGVJ8acrZwi/cqo32R
5Kq06j/IDx5pGqH743lg8G3uAkonFKgg14m0GIMTanyISvXdeT/tqvuxDxQz5lah
BTMFC52vNIB1ultG6jLlJgz4u5/WoXLZTH7wiwgMUR8z09/gAM7XTP0fNnJ+ND0H
oCyjugJXc4iC1jb812UFNS8XHm89fb9mefPCPAEiTYNnRuNfBHKsbx8N8yZ0K9UJ
XwA78eBKGwZx67lEdr0oLoUSxinp5WP7AmqShAEgrv46aWnGYvcLY9NVeyWZpZm/
F40Xpsof5O2tbsOO1olHJ/nyj1Sj9AaTbRaPlohI3DzofkyNl1WkIpfJYUi7TEFY
dhxrcl8Nk9LxQBQYBZUV
=cl3S
-----END PGP SIGNATURE-----

--=-TJUoit/MWpzM+al6r6fe--

