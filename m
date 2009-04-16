Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZDPA0V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:26:21 -0400
Subject: Re: [PATCH 2/7] ath5k: Read Spur channels from EEPROM
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Kossifidis <mick@madwifi-project.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
In-Reply-To: <20090416002449.GB4138@makis> (sfid-20090416_022442_743075_30C1D825)
References: <20090416002449.GB4138@makis>
	 (sfid-20090416_022442_743075_30C1D825)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HX/OzJcb7PvjOrNhiAyL"
Date: Thu, 16 Apr 2009 02:25:47 +0200
Message-Id: <1239841547.25334.19.camel@johannes.local> (sfid-20090416_022623_130180_2DA76059)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HX/OzJcb7PvjOrNhiAyL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 03:24 +0300, Nick Kossifidis wrote:
> *Read Spur channel information from EEPROM and use default channels for R=
F5413 compatible chips that don't have this info on EEPROM.

I think you should break the changelog at fewer columns than that.

johannes

--=-HX/OzJcb7PvjOrNhiAyL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5nsIAAoJEKVg1VMiehFY52gQAJb8WFfZbbbA7zIvIFrJS42D
f50QMDC92JczMR8Zs1OZqpxiwE9Ta24w7Y60E4dntIVcaFHNYHpgYvqeTB52Hvxp
HLLRZwGn7AA3OMAOWwnp9Bj2dEmqJi7b7NEu4RnBEWD2A9vNdQ75P12pUHbklmjU
Byh+Tk/kcOsLnDwFs9oChUskmrKvnxDaBcHNn1KahuFPmlkK/Tv/14QXb+XoFjyz
pr6r+Pfp11xwmD+esxujP9r7Ib8XVnRoqT57FB4XgrRlbTWbZ3tAYM8MVB+aSfmJ
/zXsCbkjuj7Yq6jGJci6KFcZ+zuANdE1Rzf9FscS9WeqcXsMT3GaUBPI4B4OmyWK
+d7S0xRkDQJHvX4NlXnBRWX2LsNPX/3n0zCHmUC2IhTHongba3cPEo7a0pDfuqwb
9d8H6ooLJlHoBRG+xqgh60jiySi7bxW/YP4NWFxV4yNWfF0IuHUa6IrFDR/QETT3
eSxh23y8VxNQhic6LyhSjwOzbh8IenEQJZdHOnWyGtUeBdtLvLyxSbGmu42lFSqQ
KDQMWg6Kx2vqa1RZBQGlvYlWs5dbEh8xOSjXcb/W+3rFpOzxjR4bh1rxx/iSl4wV
cxfsisqj648c8COICXh7CDRK2igiJOWQFQiVTxY6qdWKHQE6eIxOs8maJUz5GSNY
Uf2KA6r8KLfx+d+e1F9S
=mTKH
-----END PGP SIGNATURE-----

--=-HX/OzJcb7PvjOrNhiAyL--

