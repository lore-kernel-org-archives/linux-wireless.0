Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:60815 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751803Ab3FEN7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 09:59:55 -0400
Date: Wed, 5 Jun 2013 15:57:57 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCHv2 3/4] brcm80211: make mgmt_tx in brcmfmac accept a NULL
 channel
Message-ID: <20130605135757.GF2349@open-mesh.com> (sfid-20130605_155958_686983_FC85C24D)
References: <1370433187-1337-1-git-send-email-ordex@autistici.org>
 <1370433187-1337-3-git-send-email-ordex@autistici.org>
 <51AF42DC.3000001@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
In-Reply-To: <51AF42DC.3000001@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 05, 2013 at 06:53:32AM -0700, Arend van Spriel wrote:

[...]

> > +		freq =3D cfg->channel;
> > +		if (chan)
> > +			freq =3D chan->center_freq;
> > +		chan_nr =3D ieee80211_frequency_to_channel(freq);
>=20
> Could you get rid of 'freq' variable and use=20
> ieee80211_frequency_to_channel() on cfg->channel or chan->center_freq.
>=20

I tried that, but the line indented below the if would be longer than 80 ch=
ars
and breaking it is quite ugly.

> Another thing is that cfg->channel can be zero resulting in chan_nr=20
> being zero. I had a quick look whether the device firmware can handle=20
> this. I suspect not, but I will need to ask to be sure.
>=20

ok. But when cfg->channel is zero, where is the current freq stored?

Regards,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRr0PlAAoJEADl0hg6qKeOevEP/3oeGWaNjhqjF8uONN2gZzWo
jri3/oaXOMyjUspiG9IbEb6qCEz7uQCiQNHxA5NyWYC3sDsfBomshnz8u1f3+Rl8
KJz2JM6lo2k8mkKriivyqXR86vxb8AtzyyMzR7DPTFp3Wt36h1bNWfWaaRo1mfXL
BwK0jwrS3l2nAz197oy6Epk0mz+noibYVGb5fRJ+Kh01Vpbvxs4cft2gmBmpHu9V
0FeXU8PzJgA61K59TYAc8A5hPOSveoLRRFS27oQ7Z/DnW463gYSNn2LfA+yKtI9r
0rz84mjod4LNIsRxkqArf7BeUikOlSicb2GNANWia/PD7bs1yNxPYDasBERziMbu
f2GE+0DLQ9hAA3QxTY+tqKpAzppr1KEulZlBhfuY+hBdE50+1B2eUPwuT0yKGYqD
9kAJzw121h+3oMBM04yookgmF4/7ogFeKtELpPsPwdNhkCnHYTtJk7NJMvG1Oo9R
z56Eve92rl8Atk4iNJcb+R2Hh6ihu2kwL8N9xb7wN0+nDZm/1arNypI/k0x2MTW+
eZU+fto2h3oq+wZNagnncClCij32DCNX+9Bqe3D4WI3CHL0SVotwHXU4CERf0zTJ
EsK8hJKnuhwU7AwQRFRs/HDfLNlWo+tNLOTgcn1l95KL+iGHMhw5UTPUOcjvNKBc
Mq9MRsvYcadQpSuwD/O2
=1qcH
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
