Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZA1NCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 08:02:17 -0500
Subject: Re: [PATCH 7/7] iwlwifi: unify iwlagn and 3945 power save
	management
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240901280354g2c5d47e1q93ed9e9a747d381f@mail.gmail.com> (sfid-20090128_125443_236795_C09B5BEF)
References: <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-5-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-6-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-7-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-8-git-send-email-reinette.chatre@intel.com>
	 <1233137791.3936.0.camel@johannes.local>
	 <1ba2fa240901280354g2c5d47e1q93ed9e9a747d381f@mail.gmail.com>
	 (sfid-20090128_125443_236795_C09B5BEF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WDoCoDg104RgkBibOY67"
Date: Wed, 28 Jan 2009 14:02:13 +0100
Message-Id: <1233147733.4071.5.camel@johannes.local> (sfid-20090128_140220_810458_246B7331)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WDoCoDg104RgkBibOY67
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-28 at 13:54 +0200, Tomas Winkler wrote:
> On Wed, Jan 28, 2009 at 12:16 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2009-01-27 at 14:27 -0800, Reinette Chatre wrote:
> >> From: Winkler, Tomas <tomas.winkler@intel.com>
> >>
> >> This patch unifies 3945 and iwlagn power save management
> >> This patch also better separates system state from user setting.
> >> System state shall be removed later as this shall be shifted to user s=
pace
> >
> > I've got a patch to remove much of the cruft (system state and
> > associated variables etc) somewhere, can dig that up if you want.
>=20
> Send it over, better if it's rebased upon this one

I'll rebase it later today and send it to you today or tomorrow.

johannes

--=-WDoCoDg104RgkBibOY67
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgFdRAAoJEKVg1VMiehFYdwYP/Ajpjv9UfAqpwaQk9TefKe0f
kopkW9HLOdweYaDG/aa/oapEiETX8TCt0W4T/lW8AhtTmloeN3AQqoZdupHGOwNu
efEpqxtScYv2BmeKYnPGyHdq57lzo4/c2hEAatfy94s/GgwtAT/QQNvStSBnBPnb
ImiGOsDInpiba7cyym9bwwKFNcxP9tHflVlOME+3ZHvEXLKl934kLY/p6nJ+geaA
ZpSEyL3T3g2HzrKyEvkv27ZHxZVeFNGUz5wfd5C7E9gQLkYTTnA3DliP14cN7qPG
pz2j2DI9OZG7nKfr9se+zqFkU0c1E6W+XiUEw+PJvSXBr/oz8yYWqKC/U82aPgHr
GAWMOXzY6NZ58deAIKkdfv5n+AKWvm6rSKy2geWd+/1kD5a8lb+ZNeJomSA/e4m6
F5t2xypRqtPf8/hN73fd7ButUHXf96e8BL5+pptuzBe2liO2WIU1RsQ2ur2TRSmN
zYPH1MBQ3QMYRvv0xNEKuX5vssBKx2akpRAcZsXCp0LHXINylPIdIXEGCHZ86O68
LB/4u7UxuQpLwegtDKAPyIQKnp2zJMdCcxCNXPhyNpoXobzJzbK+l3gSEuxWiKcF
Tpd2z6PaLSdvNKIf/XU2KUuJD6VSs8tQ2V+WhjJSvzkefu++cdKffje6482JjAe9
y2cF3UwOfNb+6NHVhylV
=YvyG
-----END PGP SIGNATURE-----

--=-WDoCoDg104RgkBibOY67--

