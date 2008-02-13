Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbYBMNa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 08:30:28 -0500
Subject: Re: [PATCH RFT/RFC] b43: Add QOS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200802122356.40865.mb@bu3sch.de>
References: <200802122205.42799.mb@bu3sch.de>
	 <200802122356.40865.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RYqirLGUt9lzUDChVU+g"
Date: Wed, 13 Feb 2008 14:30:21 +0100
Message-Id: <1202909421.8931.54.camel@johannes.berg> (sfid-20080213_133032_788657_61D64420)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RYqirLGUt9lzUDChVU+g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hm, it seems there are two other variables in SHM we should probably writ=
e:
>  0x000E  EDCF Status Offset

Ok already mentioned this on IRC but for the record: this is set by the
initial value upload.

johannes

--=-RYqirLGUt9lzUDChVU+g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7Lw7KVg1VMiehFYAQIUiA/6A/LWiDz9uAqv+40zXzmvz4sVN9gRjyK/
7phyYQqsVJNmkGD+Iv1vB7HMtrtOEW5ZdenNGA+bIjhDRLV+usbXQ2iYp9xzGwgm
9y6BVfpUvI4Kzat+lN+LpwUDJ6B51Ds36spotDUBAMpGuO0v6w9E+Jzfs+Q6YbF5
P3lzYSB2pkdzgoib4J8Vr7G/RpNVWvwVDImhzY+UnxMbkoAPs7LDZgzQOoiLN82L
1oGiU8SHCwF9Fbb7UqjoYaht0qPnELfcY9hHzOdiSMrWK+wdp/vMWBVa+6rPajzW
FU9PZDBUCpNN4PE16shE6e4uFp0gjmPE3isx+KCTOsmFZtJf5b/D+aKuSoS+Fk9k
HJu3t+gouHlD291axozlthZXPzPTzs+g7PSufEzbi6n/DXZfUQRBTbkCGPgun+6v
Eolak3p4v93mKZLEUMRr2aG39vkJjm2E16p9x+DwNyyH5XdSwRomgzmO0Vz364Rw
12DrG3kKLok+iMPcdGViTr/Lb4Jv8vAAqYzVp4sBZig438bj8joA7xYp+3Y570uw
KF5PlYoEhtjoXbuqvWrQ8HWg6m5VYL0snWYVmZ/5ihklL6+MzfOQf04KB5MV5Bx4
FsCg1sFk9hxHoT+DMA33B4YgXyOQMRo4S83GiIVO5ODPWdNNVbJqPRYngQBD0ruc
MsL5gr47JCY=
=xNxX
-----END PGP SIGNATURE-----

--=-RYqirLGUt9lzUDChVU+g--

