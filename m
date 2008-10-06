Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYJFJRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 05:17:05 -0400
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables
	aireplay-ng and others to work
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Paul <paul14075@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223284316.2510.721.camel@debian.sh.intel.com> (sfid-20081006_111343_274436_FA74EFEC)
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
	 <1222571710.2510.587.camel@debian.sh.intel.com>
	 <7d553cf40809280059v454023eaxc8a570fb6d4efcf@mail.gmail.com>
	 <7d553cf40809281228l13414507xc11e8e592493e43@mail.gmail.com>
	 <1223284316.2510.721.camel@debian.sh.intel.com>
	 (sfid-20081006_111343_274436_FA74EFEC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sY5GRCww8a75IxrgRtIK"
Date: Mon, 06 Oct 2008 11:17:04 +0200
Message-Id: <1223284624.24551.91.camel@johannes.berg> (sfid-20081006_111709_579194_001EC9ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sY5GRCww8a75IxrgRtIK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 17:11 +0800, Zhu Yi wrote:

> I understand the current ipw2200 driver doesn't support packet
> injection. But the sysfs entry in your patch doesn't seem clean to me.
> If you can put together a patch to make the rtap interface be able to
> inject packets, I'd like to accept it.

how about making use of cfg80211 to create the monitor interface to
start with?

johannes

--=-sY5GRCww8a75IxrgRtIK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6deMAAoJEKVg1VMiehFY6gwQAIgJFxsOwkRBp5Wlu5O4snG+
LZtLr5I0hAmaaS4fm4HmLGiO+5y/9CwTQzNAuNkIfMPqUHXxG0t8bUwJhvPLLh65
RUT/QRFzfobS+hHV8KkSHwpG8YVd9j6CPgaHDPW2vFrcEZI11Co+wWHJK8oVJq0m
4ONbMiOZBe1rPIh1+YIG/OX5/yUGfgTbsBc6R0c+Cc03RqvxIwn5gdUbkyMHSljW
ubW55QqUUIPNEY8fzoqOcfqjjnyJqXjS1i9AHD1YQBuKRZX9D8aK9IZH9hi+E9dU
KH5m3RitDjFs01Jap8vJD6U+Xloo6+r0wdC+Rt5yB54+ntzTVPuzG11A4khU2tf4
BFw4lTtBeOXZtMI/fKafApQumxyXFUyZ61UjyMW0nqatIdohdzb4EK7VVMjXiazj
rePn5u5z1mdZXFNVy5zQ8tDLjo1dgi2tBjrlzPwgu45AZm/6ASG6mNCI2HtMpH+0
VjFjkmrrQF+y0eOFNvmtk7yxpiJB5nGCAsBGauQU6t9VOB1dw9bzQWU/rxELmkG4
JQ+nKzzDHkiTAz8cfhT/eW6vZR7rIKaqHO31NEaegSwNUR9e2XJKA89bJQD2coID
4q+FAGUo0p79Ostn2OpYqxlHFWGLU74XN3s4uU56/GDARQGa9eFtNkJTONHWNy8Z
bAK0R0ASKpAj0nWHbk/y
=pr/x
-----END PGP SIGNATURE-----

--=-sY5GRCww8a75IxrgRtIK--

