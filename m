Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbXLROXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 09:23:18 -0500
Subject: Re: [RFC] mac80211: clean up frame receive handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: netdev <netdev@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1197483844.6558.158.camel@johannes.berg> (sfid-20071212_182419_921972_853D21C5)
References: <1197483844.6558.158.camel@johannes.berg>
	 (sfid-20071212_182419_921972_853D21C5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SfUyMZAEGa3WRSgR9/mx"
Date: Tue, 18 Dec 2007 15:16:12 +0100
Message-Id: <1197987372.4885.160.camel@johannes.berg> (sfid-20071218_142334_566285_96A4FDD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SfUyMZAEGa3WRSgR9/mx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-12-12 at 19:24 +0100, Johannes Berg wrote:
> [comments welcome. I really need a refresher on what the frame formats
> mean but I think I did the right thing with skb->protocol here, I also
> think we had a bug with rfc2042 header frames bigger than 15xx bytes and
> eth_type_trans()]

I just discovered annex M to the 802.11 standard, will recheck with that
in mind.

johannes

--=-SfUyMZAEGa3WRSgR9/mx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2fWKqVg1VMiehFYAQL35xAAkrjdujbPtTt2VoRG3U0kqFg1CP89jj/t
5wz8SDFOrJTwx6QW/3VBtOUGkUNlVXJzik935b1bktS3uZeXBQTzhg8vuPbgncn/
vyS3xcK+c5zdWvsPGBjcMquc31BTu0js+Y/RXkGLvhDOFvfyXoFJY54k0UvlZK8z
1/FnaLykAs25klTLxuOFqf7fft7BziN8WjQnqX17s40jeZTmNcejftmbY1DCVpY/
oZfh5pj+d9M2cRIVYHtLEwnueTe/fnkaeT/XtobwTxuJt8J7p+1Qj5qVCxMOOf5s
jSIy9E66VnyxkfroxxxvqgRSk7iWixvjmLCGx5dUnktXKsXd/Xo/0w0YelcDyttI
Sq2cBNtZAEkRTd3zsDZCV+kRspl7g0Jwv22KygVQUCaXlY0CliK6rakMtazxBQjZ
G5SeliXniXbTKCREPfDh8heC374vhEOlvPLRlenCCAbZKvbC8bR5dUbuUMRXRTwF
3KoUJeOdXqJ84yNPM1sMGr1q4pHH3mmnNiykRPjXd5Wn1ZhyjNmRkULOrRpJAyvr
UrCgflYS2H9V8DFGa09Xxj0+RVN+WqpgLtBjaYBdNJt4SZErR7aJ0Hx+ZWbd1rIR
0gIcbc27CglWRrITZwlEZJAP9oZrIUOSBitMhnhBotJ5BGE8PFBWygXqCIrR6YiG
gZ0I+iaQgCM=
=u/xz
-----END PGP SIGNATURE-----

--=-SfUyMZAEGa3WRSgR9/mx--

