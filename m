Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZHBHps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:45:48 -0400
Subject: Re: [PATCH 1/1] rfkill: add the GPS radio type
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Marcel Holtmann <marcel@holtmann.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240908012249s348a2412wca21de44f9b8cb71@mail.gmail.com>
References: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
	 <1249171448.3491.32.camel@localhost.localdomain>
	 <1ba2fa240908012249s348a2412wca21de44f9b8cb71@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2dqEVKMjHwJ19EgHU41y"
Date: Sun, 02 Aug 2009 09:45:43 +0200
Message-Id: <1249199143.2007.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2dqEVKMjHwJ19EgHU41y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-08-02 at 08:49 +0300, Tomas Winkler wrote:

> > we don't have a GPS subsystem, but even without it, I think this is a
> > good thing to have.
>=20
> GPS devices are usually serial devices.

Yeah, this is interesting -- do we want something like /dev/urfkill
(cf. /dev/uinput), so that gpsd or whatever is controlling the GPS (same
applies for 3G) can be controlled with rfkill?

johannes

--=-2dqEVKMjHwJ19EgHU41y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdUQbAAoJEODzc/N7+QmaHakQAJ8MRsCtp01GCDyUubCtZvZY
jfTcB3PHGUUQtvuckq6Z8sZQBYwc9/8qcFP7cD/02RcWIn8JYgMHmL/lENAMM3zB
f9FT2+qZzw4frxHUI1FENiaaMwUAyd0aOGn3pKHuBNbDaRNvrD2lPciBZe1A3uw9
PI7u71IvU5gr3SA6bdXifb8TTA+tfcUGBA0UV8ikhnNV8pVK+aH9UPzcFNkQFh4z
HP1FGfvvYc4SZdVXb66nhYS8v9mgNWtaSrWY0GjS28jIN2mhKD88SBD4SF6RX9Ju
YY47srkzKUgm8vk+AykpF5jQet9A27v5QNGYcgM7Ry7R9hVY+AU20UiqIS2bWWsu
N96X1U8u/34DqFClBRCsA60XXG5JFxd2AXMghEfFY94S3xIUoELtEMtO6c5AcOOe
JiP9tsAzcwPWi/Q+OQHgkqC2K5iS2oBVdcIsHe06jqL6WA91jo62c53qdC41iQG7
Zu9CwoMdBOiWfmpf1bLj//3S1nbI4a12THHbE/szjt1sZInTBXEdm7X4gW5KqJAO
N3gP/ORb3BuPzTGTAjCPoyUEionvkbiJJPMklrNJw9fN/8nVj19okcEoYULIvAlw
EmkWiSix4cJZZcWBNHH9S2Cj/EWITx0/BxQYy3hyUt8mA4kYqydlIBSvzAHTo0c0
hSYLSYw45ZmSBusfo/eo
=C5AM
-----END PGP SIGNATURE-----

--=-2dqEVKMjHwJ19EgHU41y--

