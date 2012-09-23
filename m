Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:35311 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab2IWU1C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 16:27:02 -0400
Date: Sun, 23 Sep 2012 21:39:34 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [RFC] b43-fwcutter: Add support for generating a fw for
 brcmsmac
Message-ID: <20120923213934.4da339ae@milhouse> (sfid-20120923_222707_916253_D46A8325)
In-Reply-To: <1348425562-30730-1-git-send-email-hauke@hauke-m.de>
References: <1348425562-30730-1-git-send-email-hauke@hauke-m.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/z.8a+mb07YGuW8KS9EGBA0Q"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/z.8a+mb07YGuW8KS9EGBA0Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 23 Sep 2012 20:39:22 +0200
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> The normal firmware for brcmsmac is available in the linux-firmware git
> repository, but this firmware does not work on a bcm4716 devices with a
> ieee80211 core rev 16. When using a firmware extracted from the
> proprietary Broadcom driver the device works with brcmsmac.
>=20
> I tested a firmware version 666.2 extracted from the proprietary driver
> with brcmsmac on a BCM4716 and a BCM43224 and haven't seen any
> problems. The interface between the firmware and the driver changed
> some times, brcmsmac only support firmware version 598 and newer.
>=20
> For some entries in the firmware used by brcmsmac, fwcutter has to be
> more extended, so we are adding dummy entires for them in
> brcmsmac_add_dummy_entries(). Currently these entries are not used by
> brcmsmac, but it is checked if they are in the archive.
>=20
> I would still appreciate if Broadcom could release a firmware with
> support for the ieee80211 core found in the bcm4716.
>=20
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>


I'm OK with it. Some other comments?

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/z.8a+mb07YGuW8KS9EGBA0Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQX2V2AAoJEPUyvh2QjYsObpEP/jOaDf6Zeei5FJfL3hERUWvN
/pmhgNE5oBn/g0dIzz3pyCTsh+v2sM0c5rFVEDj9o1keUycOAdbY4dPwjw9ybW06
gsaQOYYchkEpQerVYi6dHBugC3pqK3b2AN0hjoRGOEuSj/14OWh/PTVANRjmGcWz
jKGOaWtpVtDSJAiRwSyw7FhJ+RJ0omMPUTKuz1Xkx2L4S4HyzucH+dOo92H+bL2S
mXSmHbmhL1DCSNU/3WerXJiCE0jF1L5aIg+NYm1kpde1oKVjny//LR0EqwHGpaU/
okKf8E/n6XO1H2qraRk/efPqlCf4lvl5r2MpW0/orOdRL0FUzYEpH5/t2+cmONgz
Dq3GmYjcnLOdovfBbdFklsxT/d5J+pj7cu0VxZQJoh8IwI+K6pi/comVtNPiZvUn
DzqSibrlk65dot71DsHzTJV0IkrGbl4QdVhuZlZ+bh3Jmq2TGiEDqk8GcTPDdnAc
05x0KQpsMTq+859ylVuKTww1YWWiY4aadQ6bS7gQsXbty0eNdb0PwwZrenepOTwG
zelDGc1ogu0Yp2vtK9KYQkJMbjsYYyN+cQSqZjWHJTPgTF89r4raSqk/oL4EfQqw
wZfOIBjIIboANjkD8DrpZ2eIkJqOP67n/aNom3nLWtr5QhikIrCU6KrwVsABQVmR
y+LaUTils51k21oabp2Z
=h83s
-----END PGP SIGNATURE-----

--Sig_/z.8a+mb07YGuW8KS9EGBA0Q--
