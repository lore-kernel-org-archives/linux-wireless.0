Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030Ab3GJDHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 23:07:46 -0400
Message-ID: <1373425655.24446.7.camel@deadeye.wl.decadent.org.uk> (sfid-20130710_050749_308268_6258F5FC)
Subject: Re: Performance regression in firmware-iwlwifi 0.38~bpo70+1
From: Ben Hutchings <ben@decadent.org.uk>
To: Intel Linux Wireless <ilw@linux.intel.com>
Cc: debian-backports@lists.debian.org,
	Sergey Frolov <dunkan.aidaho@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 10 Jul 2013 04:07:35 +0100
In-Reply-To: <20130709153104.20718ebb@thinkpad>
References: <20130709153104.20718ebb@thinkpad>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/KgZHHnaumr6ckjs4Ylw"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/KgZHHnaumr6ckjs4Ylw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-09 at 15:31 +0300, Sergey Frolov wrote:
> Hello.
>=20
> I would like to report a performance regression in the
> firmware-iwlwifi 0.38~bpo70+1 package.
> After installing it and reloading iwlwifi with a new firmware
> iwlwifi-6000g2a-6.ucode, my adapter "Intel Corporation Centrino
> Advanced-N 6205 [Taylor Peak] (rev 34)" can manage only about 200 kb/s
> DL speed tops regardless of power saving options.

This package has version 18.168.6.1 of this firmware.

> Reverting to 0.36+wheezy.1 and reloading module with
> iwlwifi-6000g2a-5.ucode resolves the issue. The AP is located in the
> same room, it's an old 2.4Ghz 11g ASUS WL-320gE access point,
> configured with wpa-psk encryption.

This has version 17.168.5.3.

> I am using linux-image-3.9-0.bpo.1-amd64 kernel from backports.

This is based on Linux 3.9.6.

> If you need any more info, please CC me, as I am not subscribed to this
> list.

Do you recognise this bug?  Can you suggest any diagnostic information
Sergey can provide?

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-/KgZHHnaumr6ckjs4Ylw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUdzP9+e/yOyVhhEJAQo7ehAA0pVVnbDDF8MJFR3hABarE7BHMb8qaKeX
n3wyBeITNIX7rVj7nzCqFZa0fqrNeOiy0vL6e3qPunhnYXPHMCdt00XhjRQSorii
YM+Lt4EJwrCfpz59PIqKUQGLrgHOjDL7jVdgCneeADjA4JfLDJ7GOrt3Pn15NHIt
YkDyg1DrEBTctQIqno4LqjiBCkTHAdMz2DyVqsquaN7WZJXrOyiuXENVAumo5ZpX
n6yVUiGBGyEIKz97SEufyvJ6iiv4jRaudENhv4mMiCB7fsDlOydiHuYiKOFjmKeS
aG0bl5qeJOs6fu8YjncDZb5fhrHcfuCb5vTX98L3JTztGUxuxN0/udH2Moq5nqeA
cIYdZItEJOmptr1ohAGEoLncf7cvXaiWvS6h+NR7ldWMoY8VhYEfaP8Tm0qTb5c+
HDZ4rQENYVEQ5fTJVkdz0IiVDfYZnnRs9HFU/T0VsvWZiISdWt7jmSZwr8o+USgo
jnWNuwAm8fK/dpjqUOIBGBY40+l9/PidOEfXJGZ6AYCpGd83ayzaLTPj61Dbgq8Z
l4xh2nbvGHXLcF0qmEsyvxq0gsTrLT2JDF8LHfMcN5eriXHXFxzei0uNB/d+g/SR
v/EGSKJeJpZegAkXVeQqpIKQvFkImfZF5J+rs30a8wh5UTlgGJGjhm6avuwjcPmP
t39xtDysRs0=
=QL/p
-----END PGP SIGNATURE-----

--=-/KgZHHnaumr6ckjs4Ylw--
