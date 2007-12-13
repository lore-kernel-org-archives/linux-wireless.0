Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54134 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbXLMTTH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 14:19:07 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <1197572204.7489.7.camel@localhost> (sfid-20071213_185719_974175_B7526374)
References: <1197412922.7030.11.camel@localhost>
	 (sfid-20071211_224234_989906_7701C071)  <1197479702.6558.125.camel@johannes.berg>
	 <1197488971.7491.1.camel@localhost>
	 (sfid-20071212_195008_015503_712CB6C6)  <1197545672.6558.238.camel@johannes.berg>
	 <1197572204.7489.7.camel@localhost> (sfid-20071213_185719_974175_B7526374)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VD9yCmbaADOukIeSHcpy"
Date: Thu, 13 Dec 2007 20:14:40 +0100
Message-Id: <1197573280.8313.38.camel@johannes.berg> (sfid-20071213_191911_371509_C7873663)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VD9yCmbaADOukIeSHcpy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The bits you're interested in are ENTRY_TXD_ACK and ENTRY_TXD_BURST.
> BURST tells the device the next frame is part of the same burst (also
> note that we have to set the correct IFS), i.e. the next frame goes out
> directly after the current one (respecting the IFS of course). The
> TXD_ACK bit means the hardware should wait for an ack of some kind (e.g.
> CTS for RTS frames).

Ah, I see. I was grepping for the TXCTL flags for RTS/CTS and couldn't
find anything. Thanks.

johannes

--=-VD9yCmbaADOukIeSHcpy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2GEn6Vg1VMiehFYAQIXWxAAtbl2v2ZzjUJkordbnmOpR3nhHAP/QTKG
E1ylcw/gaBmwIMdERmVoQJ3m3bpBVPYDuPys1Cmk3bJA0sBIrGRhSArlXLatr4cW
tbdFVHpDF+ZEeBLNwVDS9t971EPLNshB2ht0ew+Uv+w20mExBO2JcScnGDAZPzOK
Wg6tIrTeUbmOXtoON+TQe8+UkxBO4Zvqi5tpNV3HYIWanCqkB7Uo4wTNhhgpM0GA
pNITMd93YDJNz2bwyujopHXDco6B+97gHTRYtlk4Dkzhm1JTsIoaSsLKNcpqmyLb
d1Aje+EzlIDdOP3SYHuthzv3t0+GmMYHMRJpZkNbagE5fQnJU+X+XZTyTvaCWu3X
GJG2KZnGtM+mDa9YuBBMwic10DI89ZJXyUwaZo6ALrPbwqXHAZw5JhKrcsGwaVKQ
0OEacKfiC2vMz1lSaoVZsIrHQy8ThJdg6dboyWFhFek7jOJA/WET5rf0cZsaryrh
B7qNwX6zAhTNZzO1zY4LLO8CjM5kxci7WT6IvdzPeVQtbtxuJQlwEC+jdIMZzkqU
Muqr/IPp3TUu8B21GEdTRvkJL/y7k8BxHQzKmcO30FQr+MMgAJRNhZTpircbRsP/
tGbo2QuTo8CI6N6Nid+DN78IZc4eSGvqMW333JFhk2XyY+WM+PgNsQoglnVHOPXp
RvLPCP5cRYQ=
=+uQJ
-----END PGP SIGNATURE-----

--=-VD9yCmbaADOukIeSHcpy--

