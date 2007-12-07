Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48998 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbXLGVix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 16:38:53 -0500
Subject: Re: [RFC PATCH] introduce WEXT scan capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20071207192756.GA15864@bougret.hpl.hp.com> (sfid-20071207_192851_749770_5C5B444C)
References: <1196940519.3980.51.camel@localhost.localdomain>
	 <20071206191150.GC5237@bougret.hpl.hp.com>
	 <1197022818.2603.20.camel@localhost.localdomain>
	 <20071207192756.GA15864@bougret.hpl.hp.com>
	 (sfid-20071207_192851_749770_5C5B444C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7Kc5bc2WxLil3+7PWJBH"
Date: Fri, 07 Dec 2007 22:38:06 +0100
Message-Id: <1197063487.4171.26.camel@johannes.berg> (sfid-20071207_213910_942927_B9FB01E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7Kc5bc2WxLil3+7PWJBH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > >         __u32           enc_capa;       /* IW_ENC_CAPA_* bit field */
> > > +
> > > +       /* Do *NOT* use those fields, they are just used as padding t=
o get
> > > +        * proper alignement with user space */
> > > +       __s32           min_pms;
> > > +       __s32           max_pms;
> > > +       __u16           pms_flags;
> > > +       __s32           modul_capa;
> > > +       __u32           bitrate_capa;
> > > +
> > > +       __u32           scan_capa;      /* IW_SCAN_CAPA_* bit field *=
/

> 	Those fields are defined and used in userspace, please check
> wireless.21.h in Wireless Tools.

Eww. That's absolutely tasteless.

johannes

--=-7Kc5bc2WxLil3+7PWJBH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1m9PaVg1VMiehFYAQLieA//WHKPfJgaug0W8/UTrZ544339eUeYH8/y
84Kpa46D3vu5FV5SyUdgKHQ/XPJN79Sh+6WNEWTgUpB8hPR2AGjbTmwjMFY38ZeF
vi1wkw01yxjbbPKZWeQLPcr/4LHNJxeMIXf6sqAVmY2gDb8p6Ew+JXxLXmw2aZHR
l7euM+N3SVAxKVo+5FsZeKZEbrGicOcBxbvPMeXOgnBcF2+9cnr/qEOL8Fcoz6Id
NlD5fqIRmGbbSAmbK8f3s84pfYoA2nyGGTBOyxX9GY1hKg1nNzLuiiTAX+cMVTJ5
MIoukqRbl3NXUBr3Eh/VnolJrIn7AxpF9wiJ/IKJimw1lDF4D6l9tax6l3aCe7b6
FRpbtyITq/D7NR2UldpjWRtnASOVSsvBAhc+Jh7KUQa8q3NztOkKUFpweIh9TORs
Fju7Ykk3BMhVSo7pqvPUSvZrBBPb1bGebgVFNtQ+wbahPQdNMtnfKxtTx2uHy7Zt
hGqREkzes+eWorcQv0RBfz0b0P7n4cr4JLQkXi6qqzBuy87SgY/mOq7Yrpq8w0+i
FYBvTUfoYpn35f2rImAE1khnfYu6H/nZnvbrMqKTr18kqOeNEFwGi/rMMwLceI5G
qn4JPwa+AVFAGJMLMXEfgX76EwS+A/SBuRm/OZCPGoH20OAfL7JoxzdNeImXbhbj
XBK8nNWJRiQ=
=4Ax8
-----END PGP SIGNATURE-----

--=-7Kc5bc2WxLil3+7PWJBH--

