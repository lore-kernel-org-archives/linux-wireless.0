Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55895 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYLHNB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 08:01:27 -0500
Subject: Re: [RFC v2] mac80211: fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com, Luis.Rodriguez@Atheros.com,
	tomas.winkler@intel.com
In-Reply-To: <18748.62215.331271.141163@gargle.gargle.HOWL>
References: <18748.62215.331271.141163@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z+nKUV4d21HMgrEmrvz7"
Date: Mon, 08 Dec 2008 14:01:08 +0100
Message-Id: <1228741268.22164.78.camel@johannes.berg> (sfid-20081208_140129_422971_0B29689B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z+nKUV4d21HMgrEmrvz7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 15:42 +0530, Sujith wrote:
>=20
> HT management is done differently for AP and STA modes, unify
> to just the ->config() callback since HT is fundamentally a
> PHY property and cannot be per-BSS.
>=20
> Add a new NL80211 attribute to enable/disable HT (NL80211_ATTR_WIPHY_HT).
> NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET now has only the secondary channel
> offsets.

Why do this?

johannes

--=-z+nKUV4d21HMgrEmrvz7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPRqQAAoJEKVg1VMiehFYoZUP/isoR1p/9zjaXElzjUtAHX+H
HtV8Zf2WqLB4+NFKFgavMSMuSrfhmIoj29Gyh1XyP0Q/Nz9kF/p++v3v7jWAham0
BzjSvSzj3zTLl0QPF0t8pP27uDBBdO10SEssRO9nO2wGIioTN5L318SaCFR0pvW9
vqLJxPnOJEEdPv/5AA9XxQq0QYOo9ejRJ5wL4XQHlRzQdN/2qBKNEKnhTwa5ris9
SxvfbzxwTvWW7bZ2PT0y3lBus+GJbUamvETAkmrogHU14WIHK61SdXoyg5yC0SPb
81INqlK//Sp3fmcNIIuiR6BVw1POV1EntwWqj0PzqeD2v6B+ifEW+dQtl8f7ABBK
q/v3aCkBU/MbctQ+ovlfZJIxS8t1KwK7qAIyRjvuDp6l8k9OmJDyqaougXEMesHP
RT4ucErDtB7yE1H0goXVDngRojk3fuKeaNVtqgdS/hAWd/Liku47OQESkFbIZ5y8
lOLJ+Ey+qQEvBcbULJkJetEY40whyI1FsydompJMocj8bYVGPrCBcKbaBqqM3P2A
Gst5qPFEoA8AGSRxezUQYEXakDHG9iOl8H67/F4c4nkgNMUpzI85diiivEltFfx+
oSbQm4MPemzzieKKpMqVDezMOvkEU21FEw65RHtlUaqaGFZ7ckHNQe6OkZDa5kCW
S0m78rQXCpQncd1jR3Q5
=UdKw
-----END PGP SIGNATURE-----

--=-z+nKUV4d21HMgrEmrvz7--

