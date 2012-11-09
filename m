Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:38829 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2KIPw5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 10:52:57 -0500
Date: Fri, 9 Nov 2012 16:52:12 +0100
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: print the ssid when requesting device info
Message-ID: <20121109155212.GC16547@ritirata.org> (sfid-20121109_165300_255580_5D83CC8E)
References: <1352468278-30931-1-git-send-email-ordex@autistici.org>
 <1352476116.9238.10.camel@jlt4.sipsolutions.net>
 <1352476239.9238.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
In-Reply-To: <1352476239.9238.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 09, 2012 at 04:50:39PM +0100, Johannes Berg wrote:
> On Fri, 2012-11-09 at 16:48 +0100, Johannes Berg wrote:
> > On Fri, 2012-11-09 at 14:37 +0100, Antonio Quartulli wrote:
> > > The GET_INTERFACE command receives also the ssid as part of the reply.
> > > This patch makes iw print the ssid together with the other information
> > > when issuing the "iw dev $vif info" command.
> >=20
> > Applied.
>=20
> Huh, no, I take that back. What are you doing, printing an SSID as
> though it was a string?!
>=20

Uhm, right. I assumed it was composed by ASCII chars only.

> There's print_ssid_escaped() for a reason.

Thanks. Will use it.

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlCdJqwACgkQpGgxIkP9cwc41gCeKMUK3lgt7G3619eHJh4UIkhw
FDIAoIabfRGL0CpMsCDAvg/7ATqnlK1C
=kEMj
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
