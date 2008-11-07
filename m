Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYKGU6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 15:58:54 -0500
Subject: Re: [PATCH 01/13] iwlagn: fix resume for ADHOC network
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>
In-Reply-To: <1226080726-24860-2-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185819_873292_6E3A05A1)
References: <> <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
	 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
	 (sfid-20081107_185819_873292_6E3A05A1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O1/hQjlU1DuaIbLh+wnZ"
Date: Fri, 07 Nov 2008 21:58:53 +0100
Message-Id: <1226091533.11203.6.camel@johannes.berg> (sfid-20081107_215857_885352_2708AF24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O1/hQjlU1DuaIbLh+wnZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-07 at 09:58 -0800, Reinette Chatre wrote:
> From: Mohamed Abbas <mohamed.abbas@intel.com>
>=20
>  ieee80211_notify_mac only reconnect BSS networks. Since IBSS does
>  not need any auth or assoc steps we can just resume to the same
>  condition before suspend. This patch will reestablish the ad-hoc
>  network once it comes back from resume.
>=20
> http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1774

This is fine, I guess, but I'd really love people to spend some time on
just making suspend work in mac80211, then all this code can be deleted
again :)

johannes

--=-O1/hQjlU1DuaIbLh+wnZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFKwJAAoJEKVg1VMiehFYykwP/jzYWgRoxCvrWPj3FYwg6eQF
Sbe5I/RSo9IOHddRBJ+mJvhp0wtDXR0juykQgxC9UfIi9PaUPddc3OiSaxz1TnqZ
Gz/EVti0OreFHRQL9eaRhl102oXIfWY4rcWo4DEa+PDseFIfCtXNBXYCOYNf0Qpe
9WBZ9FzbFAEhORnbituEXs7Sg0L2KRwrb9ARidgZWhx8ed8h4Zxi2HV64v+IJiPi
Mrp53Ez89AHkiYgHrJUv3poHdxeoVZ4sS+SuxvdM1b/5Sf9W5RgJKEGhRx4VyuRZ
Ra0Pu2sML7U+B9bHGIcrjD0Lsw9JWADuUvfsIH3uZCQ4zsMusV4YSWUITdgheZQU
FgOaLM78+9u50qQdl7YRkEgmHJ7MH619KGmUU2JaTHpB+q5cWBtymqWIXYp+O08e
rsB2hHwSow/rRytyUOtXhz7EQJoQQGmRowIEAMOg79Shd5axHL7P5RcCm4YVC54x
ivMyjUCaWli3OJftENZ0bUozF7iHvQ3vvjZID4TejOlWsbTwqgVxRNrwMccM9E6k
kZtxdalei5seLr1TnupWORxSS7+VZHMSaP63t48ndwxp/bFZHWspJY6Yo3gkBRNT
AM44rtr1njzYRUDy3+jzW80BJRgcAbhuUVh6tSh3rQwhE4ZoXbwrt7u7bDX6eqYP
isC3MagBv5qmupZWCenL
=OIqi
-----END PGP SIGNATURE-----

--=-O1/hQjlU1DuaIbLh+wnZ--

