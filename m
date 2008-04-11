Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41931 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYDKMR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 08:17:27 -0400
Subject: Re: [PATCH, take 3] libertas: convert RSSI to a direct command
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	Marcelo Tosatti <marcelo@kvack.org>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <20080410190858.GA8969@dmt>
References: <200803261021.48470.hs4233@mail.mn-solutions.de>
	 <1206653042.21106.10.camel@localhost.localdomain>
	 <20080401031530.GA14633@dmt>
	 <200804010848.48789.hs4233@mail.mn-solutions.de>
	 <20080410154341.GB6741@dmt> <1207842441.13354.9.camel@johannes.berg>
	 <20080410190858.GA8969@dmt>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DSQP2o52Nt2LAob3nXAO"
Date: Fri, 11 Apr 2008 14:17:18 +0200
Message-Id: <1207916238.13354.65.camel@johannes.berg> (sfid-20080411_131739_074047_5E24DDAF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DSQP2o52Nt2LAob3nXAO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> True, my bad. The problem is:
>=20
>     dev_seq_start
>     read_lock(&dev_base_lock)
>     wireless_seq_show
>     wireless_seq_printf_stats
>     get_wireless_stats
>     dev->wireless_handlers->get_wireless_stats

Hah, ok, yes, you can't schedule there.

johannes

--=-DSQP2o52Nt2LAob3nXAO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/9WzaVg1VMiehFYAQKOgBAAptb8IRscVGJznKaRxeitSGmJdWJQR9Lm
bjaKjE4N2rzye+qLSVvJozS92QCFeNRlPI01AZ1kNryAqdsyPQ8hEkLENWNuvr64
SiEa9lR4UtvfqL95lXroSirn7GDIHcCBbqdFaPC3inBeTPjbew9SEGViuHhx4xxl
ELaMPQNi2c8jDO0x0bEsuGQXE4Yn0UAmufXat2HyDHzPoCvg1iXDRu+hIB+2xP64
C3xGjwMNFFencroknvU3bgMKGXbgnpQsDKbxFMaBrpOqtM930Ogvf1bOY1Ts4jSO
nF2gctS9ldvk5A/04AqjwPMsSGFs4xXWJ7AynMzSgnf5ZBDNi7Xg2kcQSIV1H6lP
SjQFIO3wdKo6IEVcfiSB9m/yEb1ZJwdz6DuFYq1iiQYUlJdqmrCRCaaE01ljvbPK
zgEHzqeSQ8lf//j0pktKw7lChEcBBa5lEaCu0PTNMB3QW38MrDYqBdvK0gguHdnm
JjpE5q+TfUjuuq4xAb10ZSLoZxhMWyev3hH9BxQ7WqGDcBj5PiT2pG7GY9BbBjDO
k+DpukMpXO7Im0sUtMZrpv3PgNNXMk1Z/WmnpWsLST7svP7FzRSohjgrQupesY79
HgcAtphUmgSbebn4UolDDG7v2EaJs+LtEsziYeJ4TUsXZy8VSHHDSQmxHqKU4wq+
PcXrjQ1t69o=
=slwy
-----END PGP SIGNATURE-----

--=-DSQP2o52Nt2LAob3nXAO--

