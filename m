Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYJ0PFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 11:05:08 -0400
Subject: Re: [RFC] mac80211: Re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <18693.53054.116942.355275@localhost.localdomain> (sfid-20081027_152757_384279_DEF256E4)
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
	 <1224493957.18024.47.camel@johannes.berg>
	 <18684.20459.335157.171344@gargle.gargle.HOWL>
	 <1224495531.18024.55.camel@johannes.berg>
	 <18684.24323.743610.871307@gargle.gargle.HOWL>
	 <1224505349.27899.17.camel@johannes.berg>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	 <1224669827.28639.54.camel@johannes.berg>
	 <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	 <1224696170.30459.12.camel@johannes.berg>
	 <18688.15460.336059.400706@gargle.gargle.HOWL>
	 <1224773201.6002.35.camel@johannes.berg>
	 <18693.53054.116942.355275@localhost.localdomain>
	 (sfid-20081027_152757_384279_DEF256E4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JwMp33viL/7uXPafoi63"
Date: Mon, 27 Oct 2008 16:04:54 +0100
Message-Id: <1225119894.3796.0.camel@johannes.berg> (sfid-20081027_160526_819113_41E61FBA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JwMp33viL/7uXPafoi63
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 19:55 +0530, Sujith wrote:
> Johannes Berg wrote:
> > We have this "ampdu_ack_map" parameter in the TX status which could be
> > set by the driver. But that assumes we only want a single TX status for
> > all A-MPDU frames, do we really? Or do we want to split them up and
> > handle it all in mac80211?
>=20
> I wasn't aware of this parameter at all. Looks useful.
>=20
> Atheros HW reports the Block Ack bitmap of the entire aggregate.
> So passing that up to mac80211, and letting mac80211 handle retransmissio=
ns would work.
> I am not sure about Intel.

Intel does the retransmissions in hw. Not sure how we'd want to handle
that difference.

johannes

--=-JwMp33viL/7uXPafoi63
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBdiSAAoJEKVg1VMiehFYzSsP/31RmkeEv/0vFz/D/ywTqnKw
J5H6bBbJfp4xsZ15JZt016zR9fKvv34XcNibJFforPy58L1bQ6YgpZDgUcCxhk+R
QHgtRj9FbFZ2k51bKvJ+GB96sl+Qgm1ka25yxUffEBH7EjVEXFwfvPMzX2QdwT2r
UxZpG8Ffwgt2SoSt1+ReD5qfT6sAM1Zn0QsdCjnxsxN6a3n1pDuMpuoRNFYfkWGl
lxX/FAe2Rn3qQCbT6gMOuySB9Psos+z/GzkAxCXNvs4Q9oqrIIUQYTjrWj3Vg/bJ
zdI/oB1aMEHHz1epSwIg9RpnC2MnDHjmhFQhZpcey72a3SNcSlj1MJo8dSyGjxGr
vfrox4Ex7sKcFB7Wz+cD74RGlfApOunwvRIecnqBFEfiLMVXV7rI60s1V1pGmJ5z
JIhzFdBOzsMHnZU6dJC0ldWQHXzCIfnAor7U2W+L6J5GMXwWl9u9KdB9hlrulf1c
SvZu1JRj29E5eTi7MIPOoM+HvLRlApb/1MK4fM1EATGbVW0Oxvp7VGjNMtggvZkT
TlvqbbH5xGxLrDOIywFWnpy83TcY42gUk23SWKJvIluU99h2LMi6fMtLvXEXr+pF
heOLNbrsb94fqO5alXakjxLCZhdJsmchdxFz117sIMokDLt97vpGveL7+HJ/K/jH
ECAACG0aMB06M3FCkktB
=a0UR
-----END PGP SIGNATURE-----

--=-JwMp33viL/7uXPafoi63--

