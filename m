Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYLJR2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:28:37 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228929820.15837.40.camel@johannes.berg> (sfid-20081210_182416_953060_7D937844)
References: <20081210150935.GA10927@srcf.ucam.org>
	 (sfid-20081210_160955_698729_A777A57C)  <1228922997.15837.6.camel@johannes.berg>
	 <1228927898.19553.164.camel@violet.holtmann.net>
	 <1228929529.15837.34.camel@johannes.berg>
	 (sfid-20081210_181928_441073_38D73A3E)  <1228929820.15837.40.camel@johannes.berg>
	 (sfid-20081210_182416_953060_7D937844)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S/+Of8MWnPZi/DF4wNf6"
Date: Wed, 10 Dec 2008 18:28:03 +0100
Message-Id: <1228930083.15837.44.camel@johannes.berg> (sfid-20081210_182842_625649_5A1FB97B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S/+Of8MWnPZi/DF4wNf6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 18:23 +0100, Johannes Berg wrote:

> Then there's user_claim_unsupported which is set by all drivers but
> rt2x00, probably because they have hardware kill switches and thus they
> have to set it even if it's not strictly true, because of the lacking
> separation between these things (that I pointed out)

IOW, correct me if I'm wrong, it seems to me that user_claim_unsupported
really is a wrong name for "has hw kill", which could be avoided if sw
and hw kill were a different thing and the rfkill structure was only
used, as I'm proposing, for hw kill and sw kill _notifications_, but not
the sw kill operation itself.

johannes

--=-S/+Of8MWnPZi/DF4wNf6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP/wgAAoJEKVg1VMiehFY4u8P/0RiT9I80Wk6GV91ZVEB+rUV
EP4K0TWG1fRiW+W+3ttLADYyUTXH+BBBdz7b3UnSugLsIknWCRSOiHfiTjxg0gFD
/SgK5C/X47Z9X59gV/OH2me02f2cS+gOA/7d2IhrGTrGXl56Oy5X+g1DaUpKfPxB
ZCsqhBwTpBr8SM6H6eByXPY3qjQ3R/T2rpfVvyTLpIlpORV68IIpJY4Y4aHvFovF
SczWlrkn0/8eV6+TtFZDeTTBknZKWEgWoeIjQpS+3IQKLgiAf2NdiCKQ6ctUPaLK
QpkWaA4eyjNe5p40brsULdzGdbf3Qy03A1euMfbD1wQcHf7YJARTPSPuE4ySnQX8
JwnGGDEgRmSj1HUNLaeeXKL0SqyHOutB0TOJZTtuLatmN1BvqZe6pD0eP+0nHUXz
4hTvEXhTmbB4pq66+LtwSX5ZvrbIJ1+J4d3IztoFVYKpFO82dGipVc79ukpfkXQj
a4OXkCb3RbHAAOCtZcz3j5ULiuXLqU8hzBhReqGCLwLRzep7KiVUZRO/OJt7O4Up
6TCwiIRRJRNWnHqcEO9PPE96KrrHcz20yHnAKgEw1XxLLMB4kfqSMUAmw2BnNFPr
xzXnHFpcjUARi76q7RIpcMwzHsWEXtZkhM8JLlADdOQPbbUMGHC0aHPiQDI1PUca
WOt8QLi/ZpO4mU2X59LX
=KV1d
-----END PGP SIGNATURE-----

--=-S/+Of8MWnPZi/DF4wNf6--

