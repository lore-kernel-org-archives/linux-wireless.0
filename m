Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZBPQEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 11:04:46 -0500
Subject: Re: NetworkManager and mac80211_hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Wagner <wagi@monom.org>
Cc: linux-wireless@vger.kernel.org, networkmanager-list@gnome.org
In-Reply-To: <20090216160016.GA29509@toronto053.server4you.de> (sfid-20090216_165945_976037_910C9191)
References: <20090216160016.GA29509@toronto053.server4you.de>
	 (sfid-20090216_165945_976037_910C9191)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WTvGi/EVsOeyltT9FxD+"
Date: Mon, 16 Feb 2009 17:04:44 +0100
Message-Id: <1234800284.4219.136.camel@johannes.local> (sfid-20090216_170449_652763_9D97D8AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WTvGi/EVsOeyltT9FxD+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 17:00 +0100, Daniel Wagner wrote:

> hotplug_event_begin_add_dev (..., parent_dev =3D NULL, ...)
>   net_add(..., parent_dev =3D NULL, ...)
>   {
>   	if (parent_dev =3D=3D NULL)
> 		goto error;
>   }
>=20
> Before I go deeper into that thing, does someone has
> an idea what could go wrong here with mac80211_hwsim?

hwsim phys have no parents in sysfs since they're virtual.

johannes

--=-WTvGi/EVsOeyltT9FxD+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmY6WAAoJEKVg1VMiehFYIecP/j92zQlP+/KGjatNVSNmkC16
EryQGgO7JziEHaMQiYiNnoQ/4Yhio8afj54zJ9omDnzuTUjoQ10lJpvIq/VpZ8Bv
p97P8f8hctOeXEPs71fNxLoAw7bK9W5zUyZ6K7K+l0YwPRTOJggB2c8sqcickH+T
Y5d02be7ENGMfvwj+ps7yCGPyFxw1IznCJsVA/D7l85an3VvMBGVln35wqS5bhn5
ll4YV5f9sSDczBAZHcjEibSQ7wrtpOkwGnvyi/Ajbu0JYdmtZ4Zvu3jRdLtjeShj
fvRZ5j5H7agQDRdYp35YYk8NCgc02boCDdN29lv8nGZ+XbjXvhSnUSxR6pXgG2BR
WlEE8gipY4jVsEhgFPjouvFXM4/Z4loOeBSLR1CNXEFkm2WdxByyqU7Os/vBq8Wb
w8tBtupgY23nR+XPfD6Fr6s7cMiXWFkm4gQBFVy5dZQ+7BD8UbG0zKjb3Nq+7ZfW
QNJq7pht90KVzXKCX/Eth0uDUD39dQRAOq5eiFD9vUl9UfZ+I2sNWxUgA5f/aEa9
i7r+BGUuoy0nk1n7+g/waeXt9heWCbAu3RpC544vZB9uzBAGRfZjDF581Lcglhpx
toaaYEAP+jAr5jU7VV87jkuW1m3RYhnYIGvn7M8r/uqgOypMMlklBwc6WHXkypeB
neVPWOXSy0Ji8uE9NEBf
=qFjG
-----END PGP SIGNATURE-----

--=-WTvGi/EVsOeyltT9FxD+--

