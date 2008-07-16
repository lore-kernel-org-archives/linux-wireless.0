Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574AbYGPNUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 09:20:45 -0400
Subject: Re: [PATCH 1/1] mac80211: add direct probe before association
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807160611h5d0d4ae5g68bfa2366cf514ec@mail.gmail.com> (sfid-20080716_151129_259863_E939246F)
References: <1216076865-9826-1-git-send-email-tomas.winkler@intel.com>
	 <1216109902.23746.27.camel@johannes.berg>
	 <1ba2fa240807150131w4a08ae6dhae7bab8ab6adbde7@mail.gmail.com>
	 <1216111065.3535.3.camel@johannes.berg>
	 <1ba2fa240807160611h5d0d4ae5g68bfa2366cf514ec@mail.gmail.com>
	 (sfid-20080716_151129_259863_E939246F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-G0WdoDs1dJdbRkgnAMLe"
Date: Wed, 16 Jul 2008 15:20:40 +0200
Message-Id: <1216214440.3422.25.camel@johannes.berg> (sfid-20080716_152049_315140_1ED45D46)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G0WdoDs1dJdbRkgnAMLe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Actually, it looks like I kept those for association because I decided
> > that we weren't printing them too much. It might be much nicer to send
> > them all as wireless events though, thoughts?
>=20
> Something like IWEVASSOCTIMEDOUT. Won't it make wpa_supplicant go nuts?

No idea. Maybe just a private event with a string? Anyway, I guess we
can keep it as-is because it doesn't add much and hopefully we won't
print it over and over again, though I have seen a case where mac80211
was stuck trying to associate again and again.

johannes

--=-G0WdoDs1dJdbRkgnAMLe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIffWkAAoJEKVg1VMiehFYsLQP/2/o3Rh2FEY/A5RobN39s4Nq
O3jEoUMY0+GIhLPm3BjKfLzw4akbVkjt4UpMwuakgafvliyueWSDXKdiX9uR5sQb
uWQNaCZpmF5apMCZtvZaAJmZBIZ0T7erWviKlOfa/nf/W6iqWS0FkOIBjhfCT9Ly
jKeubd51fJftl2h5aK4A7OEvZD0zIgrdb2yvyNIGCaRdxSswFwMI0ScR/qdxYIVR
q+My8lE/YYm2MTtJIgDkxR+RFnwi2UFwDRSylWZIfQ4o8l7FkTj5t7DNjYB9nQd0
lh6DtjLJtfGN285wqvDXJJ+uCKAsORSQCwdkKDAUUS3Qx1sYPquhQ9BFSH2cVaSV
+2Lc0H+EMCXbbeAQ7o34DisnJK1HfyX72HzOrF6xXEte6lhnnkKf5QwCBmmp1c31
w7eTexz3rKGNFvMTV/oEwlXmZjk39ffBtaGfTaxt/M8v31o2jZeKfljDUBOBUasG
YWCHYBBYtC7et9E+X6JgOJ8CBsP03p10BWYkk3Pi8J6h7h21KFK8MSu/EFp24txp
N+/2/I3eFVdW8CdxMbmCp7HPgUqWUEN9MyEmjV09L8pPXmvpVgCri26Vg4FZpH+O
iFlu3vRlwpNdWPRJ0fGMzIapyZA6DRc7GWljTlM1M09OUZ/aNx95LLaRMgeJDx9U
ZE7AQSNVRdbnAmq3VMAq
=d7LV
-----END PGP SIGNATURE-----

--=-G0WdoDs1dJdbRkgnAMLe--

