Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbYFLTm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 15:42:59 -0400
Subject: Re: [PATCH 1/1] mac80211: fix beacon interval value
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1213299517-24042-1-git-send-email-tomas.winkler@intel.com>
References: <1213299517-24042-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tbDFzvT431okODX3080+"
Date: Thu, 12 Jun 2008 21:41:46 +0200
Message-Id: <1213299706.3730.39.camel@johannes.berg> (sfid-20080612_214302_210265_9AEC646D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tbDFzvT431okODX3080+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> 1. in register_hw it honors value requested by the driver

I don't think the driver should be able to "request" a value.

> 2. It uses default 100 instead of 1000 or 10000. Scanning for beacon
> interval ~1sec and above is not sane

Yeah, 10000 seems a bit excessive.

johannes

--=-tbDFzvT431okODX3080+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUXv1AAoJEKVg1VMiehFY6l4P/RgGruAeOQL7SSdkZtwVHGfz
ILu8X1Loq3PiUfRYZhdR1Zsj3mKTtbOz15frAkV90Vs8+bS+1PIiJ6r4GJWkoHkl
iYRHGZrkjiUwBi71j8y49rygTVnwSF719WIiO61/tzCIlGuT6VRZDHS3E+w5eIra
UNKmxa9GehdDYPpGkAbKxldGm5lbm14GDwIlAKdqNhDmVuJv4j5NwvTz4zN48J7b
4BApgQPZBfo84Vw5rIKhBye+OhZuSnDnDtWs28xwouKx2kIOUNLJmC2GlaQPZZFw
9juZ68tQP3DYJyfxUqnh5b8547YhLj1XSQ/pRM5+gnkE9fD78FPuDQn6C9BVz6Au
cT4szr6EuKttlHvv3viUBReT5xfXiqsrldAGDHxzzrE1A18wuMZxm95vmvLL5opV
LaBkjs9C+bARSq7E4SavnnK/ZdVrLc3x8lxo7a7FSsTSrbkDqO3uvikNIkJXzGnd
yhfdaFxYhhoiTyDlmbSt9VMNTlcghHe7GLuQgv5U9cqgjcuM+BySfVNqMYqGtV0f
3vH6zREWY2bbOQt9HOrlehgp+Stes1O0ZUgQEhaUr8hg+Y5BvSiXnf/hekG7ELLT
IYNGmvZoI1pXjzqPIAZTNpQ7xuV+fZlMzVD7qXD/12S8cMXg8XB/sl7QIRDKJOkk
tvrQGvONA4TQ98nMWmqh
=lqJn
-----END PGP SIGNATURE-----

--=-tbDFzvT431okODX3080+--

