Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:47255 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2J2JUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:20:00 -0400
Date: Mon, 29 Oct 2012 10:19:23 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 1/2] nl/cfg80211: add the NL80211_CMD_SET_MCAST_RATE
 command
Message-ID: <20121029091923.GB5944@ritirata.org> (sfid-20121029_102003_623423_7915E4BE)
References: <1351267055-21927-1-git-send-email-ordex@autistici.org>
 <1351502016.10925.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
In-Reply-To: <1351502016.10925.9.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 10:13:36AM +0100, Johannes Berg wrote:
> On Fri, 2012-10-26 at 17:57 +0200, Antonio Quartulli wrote:
>=20
> > + * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast=
 frames
> > + *	for IBSS or MESH vif.
>=20
> You should probably advertise the new command, see nl80211_send_wiphy()

Right. Thanks!


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCOShsACgkQpGgxIkP9cwelywCgmvBD19MYiqrt74+6CbX6Ow1y
lCoAn30zqYs0eILEKOE9BS11o/c+iykC
=qbNU
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
