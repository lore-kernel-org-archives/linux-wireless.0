Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:38419 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2FZTfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:35:07 -0400
Date: Tue, 26 Jun 2012 21:35:21 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Will Hawkins <hawkinsw@opentechinstitute.org>,
	Will Hawkins <hawkinsw@opentechinitiative.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Help tracing NL80211_CMD_AUTHENTICATE as event in IBSS mode
Message-ID: <20120626193521.GB7932@ritirata.org> (sfid-20120626_213512_764524_A336DDBB)
References: <24f-4fe93400-17-239c5900@2266046>
 <1340693584.4662.3.camel@jlt3.sipsolutions.net>
 <4FE9E201.1010903@opentechinstitute.org>
 <1340728873.4484.6.camel@jlt3.sipsolutions.net>
 <4FE9E6F0.2070909@opentechinstitute.org>
 <1340730210.4484.11.camel@jlt3.sipsolutions.net>
 <20120626185533.GA7932@ritirata.org>
 <1340736988.4484.19.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
In-Reply-To: <1340736988.4484.19.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 26, 2012 at 08:56:28PM +0200, Johannes Berg wrote:
> On Tue, 2012-06-26 at 20:55 +0200, Antonio Quartulli wrote:
>=20
> > @johannes: de-duplication? IBSS/RSN assumes that each node runs an auth=
enticator
> > and a supplicant. Does this mean that we need exactly two 4-way handsha=
kes? Why
> > should we have a "winner"?
>=20
> I may misremember, I thought we didn't need two handshakes. But maybe we
> do, and just throw away one of the PTKs?

You are the expert here eheh.. but after having conducted 2 different 4-way
handshakes, the pairwise key of the STA with the greater MAC address is use=
d.

Ok we are going OT :-) but you can check wpa_supplicant/ibss_rsn.c:282 and
section 11.5.13 of 802.11-2012.

Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/qDvkACgkQpGgxIkP9cwcdAgCdGZodXL99IzWCOr85Vu6stY08
yvMAoJ2It0jYC5Fa5yxQWDFOTsTq9FAQ
=diSV
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
