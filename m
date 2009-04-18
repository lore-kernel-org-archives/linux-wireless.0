Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbZDRNdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 09:33:46 -0400
Subject: Re: Rfkill rewrite: eeepc-laptop resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49E9D5AE.50509@tuffmail.co.uk> (sfid-20090418_152951_979624_DE0ADF1D)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk>
	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
	 <49E9D5AE.50509@tuffmail.co.uk> (sfid-20090418_152951_979624_DE0ADF1D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F3tDlgiUgK13EnDqhLFu"
Date: Sat, 18 Apr 2009 15:33:41 +0200
Message-Id: <1240061621.4755.35.camel@johannes.local> (sfid-20090418_153348_998770_347C0D71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F3tDlgiUgK13EnDqhLFu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 14:29 +0100, Alan Jenkins wrote:

> API nit:
>=20
>  * This function tells the rfkill core that the device is capable of
>  * remembering soft blocks (which it is notified of via the set_block
>  * method) -- this means that the driver may ignore the return value
>  * from rfkill_set_hw_state().
>=20
> Doesn't this conflict with the declaration of rfkill_set_sw_state() as
> __must_check?

Yeah, in a way it does, but I figure it's rare enough that those who
really can ignore it can write
	(void) rfkill_set_sw_state(...)

Don't really have a strong opinion, it just seemed the mistake in the
other direction would be more common.

johannes

--=-F3tDlgiUgK13EnDqhLFu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6dazAAoJEKVg1VMiehFYEtEP/R2NINSJ52jXNgeajYR2wl/a
4TDwKJf+AXbhhoos0ObpmLp1288BgZebM+OFq4tzdhZnszHPynMHFi54n5Ce7gf6
Snf4w9lGj7zgMzbWRh94F0bgSGQRlF7+qd+zgcg9KLNnxLmULpUWIE7h50ZC5DI3
+01TwaI16U+gsV1Nv3KH6g0tpk3uTmiYNkNE/wBr/vV5LKAkgItUkQSZpg5QP51y
70ebeDp3O4xR7l1zTtjv+zJL0D8aSIG04ZExEY+rSWe4AXVlD7o7Sc8t68EiV/oh
eftFVqicUxgiybgDWgwVcng+D5wMKeHWDXwWYb+Gh1Prsyup3hYCn4Yy824unTK4
Sok9sp/VcqiNp3dZchVfms3yrQa8xoPY0Wv/hwl77Z4fQJpuSx0pvnFqT4MHJzWZ
2sf4K0sF9xarOsJ4fgzCngGXpQCWSxYNQ/+RA/4yJgvCQXvPpeJH/dGn27lknlel
WMcWUalHLIGGquLbAO4WGTa20aYHw8aBonJQRDBKxCmHnQ6EmQIYVEWL1NZ8WJ+C
tM1b70MFk7q66hRzzbboZdKxl1RguJOjbv8Re52Fs1uBh6wkQ19ChUusonXdGYM5
8D9OKRlWcwdTv6JHdvxoa769Zif+UJinq9H7K+dr2SFPgVoVMfRgte3p1jvTIPCI
owkxl8ZB+YuuQCf/C1kL
=O5I8
-----END PGP SIGNATURE-----

--=-F3tDlgiUgK13EnDqhLFu--

