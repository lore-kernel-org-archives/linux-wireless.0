Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbYIHIcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 04:32:00 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220862604.31304.27.camel@johannes.berg> (sfid-20080908_103017_215937_0F16C34A)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 <1220860709.31304.19.camel@johannes.berg>
	 <1ba2fa240809080118p26b4d984k57ce0b20a5d2c36a@mail.gmail.com>
	 (sfid-20080908_101843_062010_878B2F97)  <1220862604.31304.27.camel@johannes.berg>
	 (sfid-20080908_103017_215937_0F16C34A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dUJuQjKaKi1S2IHmbbYg"
Date: Mon, 08 Sep 2008 10:31:54 +0200
Message-Id: <1220862714.31304.30.camel@johannes.berg> (sfid-20080908_103203_075018_9482BE09)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dUJuQjKaKi1S2IHmbbYg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 10:30 +0200, Johannes Berg wrote:

> When you shut down the AP, it probably sends you a deauth.=20

and if it doesn't, you run into the same situation, the old code however
should have run into the same situation too if it didn't deauth frames,
because in the case where the AP simply suddenly stopped responding to
probe requests we removed the sta_info too. Hence my assumption it does
send deauth frames because you haven't seen this problem before.

johannes

--=-dUJuQjKaKi1S2IHmbbYg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxOL3AAoJEKVg1VMiehFY8X8QALNsH0C0wt7XBKs3UwS+FvvR
zcB/n9iPjxigjg/RLuo9zGkolvM2GcbbUSyNAOcpcnMde/BHip+xWN2Z5NbNMZgO
N3k27h0slViRtGzBeS02uV4gMWL+OG7pXrdZdbTVlYEoG029SCoNXBWOhn85tKAb
Yjrk66mJ39WRR4k+z4pl7yuiXsqU+vUz1uE7joZkUYLME1gpq51n2SF8Ge3oePjJ
Nw9/Y0D5AF5ghwWZWsYv4mXza/1TSIeS96x/HV5BM9QT5LyoltdjJkyvqx81wHQZ
mhXV64gzEIbaK+r4XcrL0guwey6Jn3I2+bgjaxGLI5/lLIJH/BnGnK8wvwb2I4so
dhefw+Qhlqv6Qj7iiiCQlv93L3Y6AB45AVbZZ29VU/bAwB6R4IIBf6XZu+ii2hRj
VMW7dBEAk+NzmQh3fO3bosbVn0Pi1VNSeyJU2jU97Y9yJg1qOb8hOAIAkCXdMdKu
Uv5Mlq9bHc9lPCrwrDo92hc1ALYXBpXshceu/D3Azgz+NLy73q9CQ+LtXPPvuch5
JDsLyApsy1OZpsSvTIKLKBpiOnotyWRhLLBfmx7MH0CF8UEfDbisIAR/vNss0reZ
yrnQmNw6T5q7pn1dKPkpofMtN/IBghpGGKqHHzA+JfgoscA9bIGrjyqStXTJ0lSz
+zZO/quL6LfTLZioeOnD
=khI3
-----END PGP SIGNATURE-----

--=-dUJuQjKaKi1S2IHmbbYg--

