Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZCMIrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 04:47:49 -0400
Subject: Re: Which APs to disregards from in inputting into the bss list
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com> (sfid-20090313_040956_677410_26120CA8)
References: <43e72e890903122009h25c7f6d9qcf4365ec32532e31@mail.gmail.com>
	 (sfid-20090313_040956_677410_26120CA8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Kg7RlYTSjxKD9laHfJC4"
Date: Fri, 13 Mar 2009 09:47:14 +0100
Message-Id: <1236934034.25931.40.camel@johannes.local> (sfid-20090313_094752_124943_26FDF1A2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Kg7RlYTSjxKD9laHfJC4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-12 at 20:09 -0700, Luis R. Rodriguez wrote:
> Do we want to ignore certain APs if we determine they are bogus?

I would think that the extra code complexity and potential for bugs
tilts the scale much in favour of not doing this.

johannes

--=-Kg7RlYTSjxKD9laHfJC4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuh2PAAoJEKVg1VMiehFYUkoQALvsGpQhYOfsPvNs29Sh1l/8
RtcDsOOpR5P97kZen7iITHuTa7uaWf5s2PqqAx1CwQfU30OtF73LoKvT3rFwznYD
5he6cyZlBfiHQ+Y7zYVLqZnhuWjiBOtU+rp1WYcavT/ZqAIaBryFJU7v/rp5ELra
sf+Q6rl9NPGDQBBAMbsQlZBlbLErxu9QpuqSzmO95NbMix7PnjXS8JsQmmhc8IO0
JdKTCea0kx1dvfL45mBPuwZUW5lyQ0mhtQPTNHg2FlND6RxUiT6BAsSS8teIo6QE
FuAiCbWKNB1eB0qRWHpgY7z1lPxqTl/NV7ZtQs9/vVpThlFZ+XfbO2bZkwtLx8we
uhmnXz6pEE7GCepFIpWARLRdP2Kc+Ezov6DxouhBSc8zG1l06/r5nP/eP6YKtRNt
gJ0bSYdttCpjIij0jFAGqWfo/E18yJeBHtDzBZAyFQDA3sf7aQA2oej8aTFtuszF
KAdkKRJzHtgLU508bkR4lXNSGfN/PosRjfNuSDIUdujeI3WE9IjdyeWpY6eaIUUQ
C8FK7lDoRMGRmVAIzRDi8iRwqM4MlIuy9xeWhnmLqdWDc6OHBzsq8y6AZTSFYihx
NXwMl2zqRT75hijN7fDB2W3SVcT1oiqZo7RvuPESS47GghiT1kv6cfdg6RbRBgg0
H+gB78xAIE9i1VhZn2pM
=/P9Q
-----END PGP SIGNATURE-----

--=-Kg7RlYTSjxKD9laHfJC4--

