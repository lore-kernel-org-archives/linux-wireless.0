Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1500 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbXDFKPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 06:15:01 -0400
Date: Fri, 6 Apr 2007 12:03:28 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: Pavel Roskin <proski@gnu.org>
Cc: Jouni Malinen <jkm@devicescape.com>,
	Dan Williams <dcbw@redhat.com>, Jan Dittmer <jdi@l4x.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Orinoco, mac80211 and wpa2
Message-ID: <20070406100328.GA3126@gateway.home>
References: <4613A4A9.1060902@l4x.org> <1175697737.2656.3.camel@localhost.localdomain> <1175700158.5322.9.camel@dv> <20070404153814.GC8229@devicescape.com> <1175703938.5322.21.camel@dv>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
In-Reply-To: <1175703938.5322.21.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2007 at 12:25:38PM -0400, Pavel Roskin wrote:
> On Wed, 2007-04-04 at 08:38 -0700, Jouni Malinen wrote:
>=20
> > If Orinoco cards added WPA support in the same (or similar) way as
> > Intersil Prism2/2.5/3, firmware support is certainly needed. In case of
> > Intersil, it was needed for adding WPA/RSN IE into (Re)AssocReq and to
> > receive Beacon/ProbeResp frames (to get WPA/RSN IE from AP).=20
>=20
> Since Orinoco 9.xx firmware has explicit support for WPA (at least for
> TKIP), I guess it could be used for that with or without mac80211.

Do you have any idea where I can find 9.xx firmware? The latest
firmware I can find for Orinoco PCMCIA Silver/Gold is 8.72.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGFhrw/PlVHJtIto0RAh42AJ9A73ldpkQglHzjoGwAOkFmoV23JACeOvyZ
pWL5vzzfixCuXOd2SQ4i4fs=
=gAzL
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
