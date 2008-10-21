Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYJUVfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 17:35:07 -0400
Subject: Re: New iwlwifi 3945 uCode available
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: reinette chatre <reinette.chatre@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com> (sfid-20081021_233334_570632_4AF554DC)
References: <1224613633.10863.43.camel@rc-desk>
	 <1224624324.28639.9.camel@johannes.berg>
	 <1ba2fa240810211433q2e7a13b2p45cb8d38a74393c9@mail.gmail.com>
	 (sfid-20081021_233334_570632_4AF554DC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O9zzwAq89WKeL3rF9lHY"
Date: Tue, 21 Oct 2008 23:34:59 +0200
Message-Id: <1224624899.28639.17.camel@johannes.berg> (sfid-20081021_233511_974772_6EF373AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-O9zzwAq89WKeL3rF9lHY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 23:33 +0200, Tomas Winkler wrote:
> On Tue, Oct 21, 2008 at 11:25 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2008-10-21 at 11:27 -0700, reinette chatre wrote:
> >> Two new versions of 3945 uCode is now available for download from
> >> http://intellinuxwireless.org/?n=3DDownloads. Two versions are availab=
le
> >> as we have updated the API version of the uCode and included pending
> >> fixes in both API versions.
> >>
> >> Version 15.28.1.8 supports API v1 and can be used with most current 39=
45
> >> drivers. Version 15.28.2.8 (API v2) is required when you start using t=
he
> >> latest 3945 driver from wireless-testing at the time it includes the
> >> patch "iwl3945 : Fix a-band association for passive channels".
> >
> > Can you make the driver work with the old ucode? We even do that for
> > drivers where we don't control the ucode like b43...
>=20
> What for?

Well, so that installing a new kernel doesn't suddenly break your
network connection and ability to download the firmware, for instance.
If you want more arguments you can go read all the "b43 sucks" threads
about it.

johannes

--=-O9zzwAq89WKeL3rF9lHY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/ksAAAoJEKVg1VMiehFYXkoQAIE27i1qibZDpP/ZLqYGSmET
IXhdXbT0fY/7jCeM8nT/ShYdWIbpmYZvl/23fc1JpvVsLCb08y8W6qhbyISwN4uQ
keHuWvLQJsnKUwcQrIY4kPIKEsZBYo1gXloAVPu11K/t7sh7ujTTZNaN0BVXtC1t
QRVF6vmQTx/zKNAMvEjBwH2kx1OEGHFeAFYQgdGAyD+PZUCBMjgL4Q2V0MIvkvAg
UZZCII3Y8hhuSj1aizTRiJbbhgjyKxs+dX9IXnlDatoGHuEUpkOIAzksGlQPStJe
ax5GQfI4jI/ZpouLidrdva637afkeb6bd+Tqqd28cXjQIPB2+poKJrnd04VC+N1d
9LABzYDwWCatBfqTsGjhtZu5f+JbWJhepOBxRoesyGkrl1OZKTUeQGW6taUIFaJt
5lDbyb3dgTfkikZVVnltqiEbzgTrwKI6YbciokY8YrlJXQRExyY4KOBUc07vBMXu
/pWZ8UNwA9D8qxvfCtVGXZkYTYsztyTFiDKssnWJadIY8GZFZ1iUDqoN79trdoWj
Mdq3kbKQ1c7Mh3YKhEwmGNT25VKbRIqSm6Vlrra5UhjfQVW33lMyoroHbFbpCzMh
O+pZWp74mIgyuPjUuwvZlsnxwE3cFA7hqowibYzxggyTIwsHP9xMSadWBjuAG7Bm
DWPq7LUuDnJJQRDHK7Ng
=OEe0
-----END PGP SIGNATURE-----

--=-O9zzwAq89WKeL3rF9lHY--

