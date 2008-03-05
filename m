Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760784AbYCEKmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 05:42:54 -0500
Subject: RE: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags andHT
	flags
From: Johannes Berg <johannes@sipsolutions.net>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <C07C4589BE74A34981C3C3525EE1F8010378F341@hasmsx412.ger.corp.intel.com>
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 <1204710116.25502.48.camel@johannes.berg>
	 <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com>
	 (sfid-20080305_100051_308051_571E68F9) <1204711417.25502.59.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F8010378F341@hasmsx412.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0OuPXMuNsJwbXyMRzn6Z"
Date: Wed, 05 Mar 2008 11:42:35 +0100
Message-Id: <1204713755.25502.62.camel@johannes.berg> (sfid-20080305_104304_577984_B9BCBB99)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0OuPXMuNsJwbXyMRzn6Z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >Hmm. Can you explain the new HT flags a bit better?
>=20
> All the flags we added are from spec there are not 4965 specific=20

Still? I'm not intricately familiar with the spec.

> >What, for example, is OFDM_HT? What happens when you select a bitrate
> >of, say, 11MBit and have the 40_MHZ_WIDTH flag set?
>=20
> HT doesn't work on CCK modulations, so this flag just basically says
> it's HT rate and not legacy rate.

Ok, so what does it mean to set the flag along with a 54MBit rate?

It seems to me that these flags aren't entirely orthogonal to the
bitrates?

johannes

--=-0OuPXMuNsJwbXyMRzn6Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR855GqVg1VMiehFYAQJaJxAAujxrluwF95/qPFDqvuFeHerk71kKhkZT
8VXZnLP+PKeXrdqU435r6DrZECJFtrXq2bOXew+pw0U4232XUlszUJB+KlXZ5xbG
Sy0v0xz9LAqq5bUWLDkS2eEPRSTSQdgQuEiBFKj4FDGg0igyzLTy7H0NOHptfxbV
VkBeMsezUXBsmbbMz6E6kiQopTsr3fW3vViLaK5MoIU7uDdt8RK24JahjV30Hyxh
Yc+o4Rmfcn++qAx8BYKj7C9t2KXTiQ0ZZHZqqkMIkc2qPXnFJKLbnrQP26gFpFPd
DEbuPXExysFlVdm3+hDtDWLva7lzyZJPBtDXATZIGHsgADZOm2RO+GuK4PCn2ggs
+IvSY0F/vG5HTJEDukCHiR+s0/n1s4Uw8KJuwJDMuBVuH46tvQ/UKDL/QBjuxkdM
F7DZpcxKyyzu3qzusOc+LxBco3TYpwsfdQJg3lH2DYyC/fQsULQdzZ7UDZI3dSJG
pDohb1xO5jy01tj9YgHRMepaC16PReQle7QgVVi7OlqJDDJtTwhz77fmUDVkQ5vQ
BXeyuEVWupuFy8Zr6i5gN3RGmUmdf2pykqr4+HNY01TKiDgD0lB1zFU9Be6hV1jS
xiITVZ4qDVUCgm+LasHKcz3Qx34QXRIaPicjuBGrn2JwDZ/333yb9zVLmLySw/eg
70kI1F926ac=
=PRCw
-----END PGP SIGNATURE-----

--=-0OuPXMuNsJwbXyMRzn6Z--

