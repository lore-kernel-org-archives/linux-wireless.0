Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXLCKmk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 05:42:40 -0500
Subject: Re: [RFC] mac80211: don't use if_id, use if_priv
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <43e72e890711300833m20bb79ffof1cc228c6ec4922c@mail.gmail.com> (sfid-20071130_163345_344106_A3FA7031)
References: <1196423301.6058.187.camel@johannes.berg>
	 <43e72e890711300833m20bb79ffof1cc228c6ec4922c@mail.gmail.com>
	 (sfid-20071130_163345_344106_A3FA7031)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+KiqtcNlb5uPdDLnTBzY"
Date: Mon, 03 Dec 2007 11:42:31 +0100
Message-Id: <1196678551.6060.29.camel@johannes.berg> (sfid-20071203_104243_359650_1C408739)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+KiqtcNlb5uPdDLnTBzY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Comments welcome. I'll be improving this and making it at least compile
> > with all other drivers.
>=20
> What will ieee80211_sub_if_data's if_priv look like?

It's in the patch, simply

|	struct if_priv if_priv;

and then where needed we take &sdata->if_priv to pass to the driver.

> >  Maybe "struct if_priv" should be renamed?
>=20
> Yeah, hm... mac80211_priv, iw_priv, subif_priv??

Yeah, I'll search/replace to something better.

johannes

--=-+KiqtcNlb5uPdDLnTBzY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1PdlqVg1VMiehFYAQJSrQ//c5VT75O/L1As1VZtMOCJIj9FCgLFkGx7
DtHCzikw/dZC6N1q7nCFA5hGaZ6B0+J825sDgFQYwPR7LHDD8ExPI4NpJCVp1Vq/
9wVkqyovwzeuc5Z8utXL0J2gEJB8kbPz8Ltp2AwyThJNLW29Oj9ZysON669ZlImE
gP/OEQr3aHe1/FJvsiViab3MH9pAYIg4CtoW5C82Vk0m/lgEp/7GQjCK5Yq2ixNT
q4byBAKhfXXSRCR1gqFs+ccMs/+houg5J4gMlqMbx1S7PyhQ6ykQMuMOWpiikTkb
Q1YlA2BDH8xvkg2gwP+Wdb8Z7BXNmDK71LbcvQz3y6clX/Jv0GHie7APmweJ/MPJ
Uml79rfYprwTQI8+xRF5iqmCdXiikPmIp3JZFPZNt4/w4omx5ThqTpf5+E/P6rjs
LprQdWbmHQV2NcwLfAygE12dcVZYilbIDPhwYFz+F3sNqzw1xJgJhZjgadmZ8+/T
MxR+zttHwTdg37H4FFy3G03zkLyOe1eqEkXblbg15pZ1qGXNoeyLpJxeIhs1Sbno
oDXXH3sRYFmO3ShSbj/CtEu2Fmc4WUqJjJzC+mvh+QtJw5gh9ihyhpANsW1+IBG/
6Ag4Ot60paxbe43sKucf1ki+OyXIZ9FWYtJjSPASGRKOn7knAixyseiV3qi2Id+W
94bOt6oOqbE=
=+Tx0
-----END PGP SIGNATURE-----

--=-+KiqtcNlb5uPdDLnTBzY--

