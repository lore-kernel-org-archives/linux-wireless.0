Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38170 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYG1NX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 09:23:56 -0400
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1217172136.2700.21.camel@localhost.localdomain>
References: <48763814.27052c0a.1794.2095@mx.google.com>
	 <1217172136.2700.21.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G9iWzfDjI2Xp+ovnVC5Z"
Date: Mon, 28 Jul 2008 15:23:53 +0200
Message-Id: <1217251433.12662.5.camel@johannes.berg> (sfid-20080728_152359_549169_9CA1CC73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G9iWzfDjI2Xp+ovnVC5Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-27 at 11:22 -0400, Dan Williams wrote:
> On Thu, 2008-07-10 at 16:57 +0200, Luis Carlos Cobo wrote:
> > Originally by Johannes Berg. This patch adds support for devices that d=
o not
> > report their MAC address until the firmware is loaded. While the addres=
s is not
> > known, a multicast on is used.
>=20
> Johannes, thoughts on this?  Is there a better way to do it for devices
> that don't know their MAC address until firmware load?

I actually wrote this patch, but largely I don't care. It seemed that
having unique MAC addresses would screw up less with udev, but maybe we
can just leave it zeroed until we know?

johannes

--=-G9iWzfDjI2Xp+ovnVC5Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjchlAAoJEKVg1VMiehFYDlMP/0g8gYF4mLiUzOCGS9iRl/9r
2CtctWuS0lbVaDH50zEl+fMU6Z1O9iHIiAHWPK0rCTuknXRsv4QApipBYitBUp+P
5LvqNu6jtaZhnyqujoWr1GLSlTKCMAQqR5UEe439su0YV1wQZ9tguQCz+wfN7xZw
tYnwZA9QIZ683HBhI2f8Lj+CHQXR6wV1wiZhGCI8SzygTm1moQf5pTOeq1GB4Yed
OV7neWQHCipSJDvZ1ilcKwFccrvRKhVgAsr5N2E4pLOTHqUrOI9ncizzqde1o1YT
DOzBRGcKquQ7pri57OzG8vHuehFPBoMjcVceG/CYkzdRGXhqrXphsZL0FwCC8t9Y
3Zs2Ma+tGIBK7JT0D6IcVOeE9lqRLH4y0MyXISf6AOqUUIRLidlm8Omu+A5xptq2
0vt9kTCbLxXOe2m87uGSk0G77fhh/0GHyugR4at0WujQc170UroGwwvkVfooe17w
ldpLiFgMzMnUNk70MKms1xVIjbIjwDoHoqHANa3+e5fwofJiT2elkWoMTfkZN4GN
znM6NiaSgarT2/buXegoMSqFn9LJWl9iDCx3DGdqOOO7/ShCZb6Jrw6pkoo+5Ae5
Tw62SLpk4z0019/O83UvIXz8wX26f00XR8WzXB0qQ3c2x/eL/6L96dmyV7VqDrAR
fZEwJ9P3DbYqfNUN/4hs
=fdQ0
-----END PGP SIGNATURE-----

--=-G9iWzfDjI2Xp+ovnVC5Z--

