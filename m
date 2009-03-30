Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35287 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853AbZC3TBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 15:01:37 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1238406057.24972.23.camel@johannes.local> (sfid-20090330_114105_983781_83388221)
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3)  <1238406057.24972.23.camel@johannes.local>
	 (sfid-20090330_114105_983781_83388221)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Z26DkB8OVxR5pTPsMYlb"
Date: Mon, 30 Mar 2009 21:01:02 +0200
Message-Id: <1238439662.5970.29.camel@johannes.local> (sfid-20090330_210140_842616_5ECAE0A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z26DkB8OVxR5pTPsMYlb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 11:40 +0200, Johannes Berg wrote:

>  * b43/b43legacy
>    -> compiles now, but should remove input polldev and use hw block
>       polling -- later

done

>  * tosa - done now in new patch, but not even compile-tested
>    (http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-rfkill=
-rewrite.patch)

need to take care of LED default trigger thing here

johannes

--=-Z26DkB8OVxR5pTPsMYlb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0RbrAAoJEKVg1VMiehFYfAIQAK73FIzcy77xJPIStUy3x+6u
CfF4P7dkk/OUEGdsq5QQZIUEz0kR9cb9Twv8w2/PebhgisrTDlVKcFYfZPbVuood
T59jh/gm53PVhAfryn1VSW3gV8vIftb9Ch1TO1JgFvFy4QvQzgbUv6Lq43M10Pw4
ImQpOPe383E07Q4PDxAP6YI4KE4IdeEcNx9JCzgE/Ig9ICmio0ED9tD2lA0t1ikM
bQ3IZM3XZpdCvWPovPW9FX40a21DM/gpQXqVZwytv4uLbOBotuLFB5LjC+PmnVJR
XCBp4k5vnyZRA3m4BI48xXGaORWQPB7hNQSBKz3HYWhviHzmdv1al0rNGnYQXbnp
08COTz2thW+g/K5P7myvaDVOXp7scy2wp2SHqsAUO6Y6B0ZJZSMDQBKe8c5y0g+S
OtA2x2PstITzbkyo2QwdKOzRLgcjvjKaS9yLFGMURx/en/TNRI8YtTvw/AWMgGIN
Qx7nHlX4CXZQY/pF68kOA4bdq+0J8fE4AhbCS/as9IZ1ZI/l7VmD1FtImfePZINK
TymhoB7vipZmFtSOv3JFmimzOplc80Xj3xQ9q61o51LRV5AN5Bqdxowr6jIv/TZf
VVOCRhduc0m4BPr2IwIyD74t+eS3kV8lBSC3hwH7SPQn3dgDUAEgtn7GnD4vOqom
LMAQXz1ppNVR/zKhxZHY
=5G2x
-----END PGP SIGNATURE-----

--=-Z26DkB8OVxR5pTPsMYlb--

