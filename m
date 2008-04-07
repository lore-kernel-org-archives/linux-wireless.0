Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYDGNK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 09:10:27 -0400
Subject: Re: mac80211 hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200804051931.58895.IvDoorn@gmail.com> (sfid-20080405_183029_572967_86DFF20C)
References: <200804051931.58895.IvDoorn@gmail.com>
	 (sfid-20080405_183029_572967_86DFF20C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WYQgk9iCDW9jP/FXmcxt"
Date: Mon, 07 Apr 2008 15:09:21 +0200
Message-Id: <1207573761.12481.4.camel@johannes.berg> (sfid-20080407_142554_399047_9531DD74)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WYQgk9iCDW9jP/FXmcxt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ivo,

In addition to what Jouni already mentioned about replay detection, I
have a question.

> If I understand correctly mac80211 is inserting the values just after
> the ieee80211 header in the frame.=20

Well, yes, that's where they belong on air.

> Now there are 2 ways rt2x00 can
> handle this.
> 	1) copy the frame to the DMA in 2 steps, skipping the inserted IV by mac=
80211
> 	    and copy the IV into the descriptor.

How much overhead do you reckon this would be?

> 	2) Add flag to mac80211 to provide the IV and EIV seperately to the driv=
er
> 	    so there won't be overhead by mac80211 to insert the IV after the ie=
ee80211
> 	    header when the driver doesn't want it to.

I'd prefer 1) over 2) just because it seems a rather special case for
this particular hardware.

johannes

--=-WYQgk9iCDW9jP/FXmcxt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/odAKVg1VMiehFYAQKOCBAApNLWe94VfpDtdOV8B+GoBcbeeqOohcdE
rgQHacZ3JNyYrhTw4OBZ4D6tjAUUOy8SuL7UnyJEL13w6L6zqPEXyz8OY+uTOlXR
MWEZ1EITWEQEveufZ24um80w6MHiIW/DU/hGvDvVfSThssQ5DVVBvaZLZ/gvhIVq
JmAjiDg5kaoakED3RJ6C07aFwp9M2Jyo6Khzj7MK0xg7ICIknd7z4Y4x7Bh5Iu8G
tsYrZ4aTylj8E6lP93Z/zvpd34KGqjdW6SfnUi2jmDPQrpA3/tytseqBUrezSKDy
7cq6mtoN2juM761kZ3/WfzxTtRdYjMT8Hd6GFwZHC33Z9lI8uCKIlYfXpXh91CRp
Yp9sQYbzyQ58Or5M2nEyam1qbB1usTqocLA9aWUR2G9yKCBXOLzr7mhpZ/LYvXrK
G7ATsRh144EqRWaprbCSzH1TqytwwvSe6m0kjU8sbor3/BCUxsewKMnYssegDagt
nCyd3jSo0LYWxSV9l3WcUanOag0morvXkn8229I4boGo4GTDuc+68IwNGDmMLjpW
vt80EKOQdFAWVRPPRat/Lpn8f9Coh3J2m4iyF47co7WJ0YFD3QBsDn7jdwaC2ecV
yJpTb85+dfqm1s3SG1/Y13R9MCXr/aS/jrvEyF3hwqjWp/R82Iirz6FWKQPeyqJX
/WRv8bFk6Yg=
=p5TO
-----END PGP SIGNATURE-----

--=-WYQgk9iCDW9jP/FXmcxt--

