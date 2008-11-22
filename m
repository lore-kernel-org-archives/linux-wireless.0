Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758732AbYKVR64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 12:58:56 -0500
Subject: Re: ieee80211_wep_encrypt_data_fix_unaligned_access.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Kuten <ivan.kuten@promwad.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227374306.3599.12.camel@johannes.berg> (sfid-20081122_181834_907517_E055A678)
References: <eaf88bcfcb5b61c24cf1b8b682c5ff3c@promwad.com>
	 (sfid-20081121_234653_121082_4B762D50)  <1227374306.3599.12.camel@johannes.berg>
	 (sfid-20081122_181834_907517_E055A678)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BypvYyMSEPsTB8VGL31Q"
Date: Sat, 22 Nov 2008 18:58:53 +0100
Message-Id: <1227376733.3599.22.camel@johannes.berg> (sfid-20081122_185859_959849_AFDF9891)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BypvYyMSEPsTB8VGL31Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-22 at 18:18 +0100, Johannes Berg wrote:
> On Sat, 2008-11-22 at 00:46 +0200, Ivan Kuten wrote:
>=20
> > -       icv =3D (__le32 *)(data + data_len);
> > -       *icv =3D cpu_to_le32(~crc32_le(~0, data, data_len));
> > +       icv =3D cpu_to_le32(~crc32_le(~0, data, data_len));
> > +       put_unaligned(icv, (__le32 *)(data + data_len));
>=20
> Aren't you putting a pointer now??

Never mind.

johannes

--=-BypvYyMSEPsTB8VGL31Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKEhZAAoJEKVg1VMiehFYyOAP/AveRvAqaMKxqHnH6RLOQHgX
bfTX3W3WPFG9eDdLVkexdtlpdUpG2iEvrZfzJb71ORVJ95WBGbSG/STKXG+sGHe0
3aG6AR+GJd5+9zWlAlk3KXgS1t5Kpsvd6ERiw1hO/QKPRRjwO+czlRqUujDbtPqx
2RGTiQcyypS72B8FGKbjGXL7yMOrlaeY+Hat+7Fmf2wrpMK9q6qHLTnumILoXJCD
aeZMXE3GHACYxu2i/dJBUeeezFE5N+XvELhfaAOUvdDs9ZyZzRi5mkWziKkmIx39
Do7p/r+/DZZ9XS9x3Sw9vXcugSYuX19KKooXDjDOo8TfH2YdZrqTLh2GYmKKrozv
DxNFVIwg97EkdFVYTFnPohscL5FSjLq3YIzk0/FSLqoJP2vANJ3vlE2eoR814XPA
cp7pUvQNwQzxs913xgolNXTv77ZFxmYiKEDY2/jyRd6DzXjmedEg1jh9iyngdvQ5
eaItj6n/6GMlwF4iWOnLg/GXdM9+N207Dx5Ms/YiMqqJ60c4phTCxMQVL9UnGmu4
vf2jRvkosC4Rx2JHfkXPTwCDOMV+XtqDD14Lubzj+pkvaJZolXl9PWvA9dII/8kY
2ctbvIrrAWyTC8bwEvW/PYVwtsYsyFKZ/XjFHhj+Q7E0zLs74y97OZCpOpyVO9pu
pWyuMAody20AegpZ+QWz
=Ijwa
-----END PGP SIGNATURE-----

--=-BypvYyMSEPsTB8VGL31Q--

