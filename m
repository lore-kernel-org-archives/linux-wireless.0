Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbZIYFUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 01:20:46 -0400
Subject: Re: 2.6.31-git wireless broken
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
	 <1253813740.3868.324.camel@johannes.local>
	 <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
	 <1253816614.3868.406.camel@johannes.local>
	 <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SMr3CbQWtheGrG4QDc6f"
Date: Fri, 25 Sep 2009 07:20:38 +0200
Message-Id: <1253856038.3868.500.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SMr3CbQWtheGrG4QDc6f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-24 at 20:45 +0100, Hugh Dickins wrote:

> I've now tried recent Linus -git plus both those patches on both machines=
,
> but no joy on either.

Thanks.

> >=20
> > Anyhow, I'm grasping at straws -- can you tell me more about the failur=
e
> > mode, and possibly enable CONFIG_MAC80211_DEBUG_MENU and
> > CONFIG_MAC80211_VERBOSE_DEBUG?
>=20
> I enabled those on both machines for that trial, will keep them on for no=
w.
>=20
> The failure mode is that iwconfig says ESSID:off/any instead of showing
> my essid, and I've no connectivity; but you probably need something more
> specific than that.
>=20
> I'll send you privately the .config of each machine, and the dmesg of
> each machine, from that trial.  I've just compared the .configs against
> what works for 2.6.31, and everything relevant still seems to be there.

Very odd. Haven't really looked at the config, but I see the phy0: idle
message that indicates you have debug on. However, it's like nothing
ever tells the kernel to connect to a network.

Are you running wpa_supplicant?

> I do wonder if this is an openSUSE interaction, whether another distro
> with the same kernel would be fine.

I'm not sure why that would be? But then again this is the first I've
heard of such a problem.

johannes

--=-SMr3CbQWtheGrG4QDc6f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKvFMiAAoJEODzc/N7+QmaNAMP/jECxQLfahKkt2TStazpOb+l
wMUoYAUldqD5x6V7qqneucFjIk+fwHC3XJA4weckbxOa6WBEgM/R5hHjRL0sHBNu
XKpUHMX5i/ucTcInBw6xmtBEOLEO4k7lHRlULb0p4ABLKZp7lSB7Gk3sRYHod2zp
BxEfZ2NhxRimGFI5U5RuWezmZJzfvRUeShpbTgA5HJ0UXDZBw5BP1QNg63P4KT+g
dIW/LZK69NC62uqdtEjTltcYPa1CtzYCrqHC2MryDavSv6ECtO4DqM00ZGIZrETu
B0e+HJhee4LQ2XULTHTSAGhUSnaqsVQdyWN3qqRUBS81bNEcvbcVGLvvcy7iEKnl
fVr/WTYx38Cc13zicpaYodosfMIEh4Ru2hFhKIxOipFlfs+AfvK/WPO15vRDp9yK
zx8tGZplJ/6lHecjo4J8ET1XjPUjK260U784rIQgQci/16gG2o7SCYLPXQ6kkmuy
LeUWah/lG6l5TDgF4JAIS2rARf28tejiwSATvdPt/TF/UmXTciOynexNM8U6Z6oF
n9FCCNxWJYMJQ1TtNDrNaLoE1Xw3wTCRunpkGVTdEgkrw18npcxwx9qp3hhaxrcl
z0Y9IIeawGC8XeHnk68wmYAX5Ze4B0g7CSTKb+b+XhCo33k64UYn22waMq8uX6kE
TEM0yShHB+5m5s7ptS1z
=cYXk
-----END PGP SIGNATURE-----

--=-SMr3CbQWtheGrG4QDc6f--

