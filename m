Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56425 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZGRRkI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 13:40:08 -0400
Subject: Re: Rfkill rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A61EE43.4060003@tuffmail.co.uk>
References: <4A61EE43.4060003@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Esg4R7hDs1DWePUF7ak0"
Date: Sat, 18 Jul 2009 19:40:02 +0200
Message-Id: <1247938802.18391.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Esg4R7hDs1DWePUF7ak0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-18 at 16:46 +0100, Alan Jenkins wrote:

> It seems my GCC has a stronger definition of "must" than you do :-).
> I can't get rid of the warning by casting it to void.  So I'm not sure
> __must_check is really appropriate here.

Heh, my gcc agrees with you :)
I'm happy to remove it -- want to send a patch?

johannes

--=-Esg4R7hDs1DWePUF7ak0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKYgjvAAoJEODzc/N7+QmaHUAP/2LeBkvN36K7REwAQkMeg1mf
1m2W/HA8qrWK0j8EkDuQAMibxB4W9nLYmquTW1CFSFxFuvR+kTKT+cWK/2vJFIyO
haDy85HQY3f3kS8L/8vAp2NuCO/D5ns2g2IHnQrzNN3YOvrHL0eec9Ys461zvaEX
+BD7v5oVOYdtd/nL3YpkVhgsu7/lxBIsGnQfBvlLMtZb4RSfOMs/Q09qyvv2pvlA
BAhYh88nbAAWfwjJAoQTl4LeIPo1u9AVqBPaIfoLHezjAvJ2hQ6rdKW9gYoflyPb
eA9zpsyfIjy+SmuZf1gEdzG2B2iqt7KfHUoog86nKCGG6QZ3DVATZXyM5WGjBNXU
igVlA/YlLVSXcIEKcXfANC4xBt6VzhFee2aDLquB5/ILyHL98uPq6KPb2WMtV7sP
L0SSH404VeyyWXE2To/QRbQ6BsOBNybKHVwtZCREBXwjnC5n//7944yPFsFiVWkE
zqg+rvkFLosGINtkm0ztd+hqEpaaXxgpCcGFz+xnkDmzwQTsIG6Gh+UiQ7BokuZL
0zs6+ssL1JhfLW83jHgPj/lCr75Il1Y/ucCmkpCqTrrk62sibHF1b0jl2NuWMa1E
ajgHKLaqE7ymw8f4c88ja7AqALZLT0xrpKFFezsq3s9L62d3y9OVcaq0BxhXCs5R
MHihSNPFqckf+569A0zk
=fo7d
-----END PGP SIGNATURE-----

--=-Esg4R7hDs1DWePUF7ak0--

