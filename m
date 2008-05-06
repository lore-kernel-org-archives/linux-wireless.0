Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYEFJiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:38:50 -0400
Subject: Re: [PATCH 25/25] iwlwifi: map A-MPDU HW queue to mac80211 A-MPDU
	SW queue
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <1ba2fa240805060211j3730f29w30313dcb3fd34c44@mail.gmail.com> (sfid-20080506_111043_286335_9ED98D33)
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-24-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-25-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-26-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240805060209x3765abf6lf5ece51055b0d60@mail.gmail.com>
	 <1ba2fa240805060211j3730f29w30313dcb3fd34c44@mail.gmail.com>
	 (sfid-20080506_111043_286335_9ED98D33)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0VauDyUhEheDM74yUYBn"
Date: Tue, 06 May 2008 11:38:08 +0200
Message-Id: <1210066688.8012.75.camel@johannes.berg> (sfid-20080506_113803_164790_8A4B5313)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0VauDyUhEheDM74yUYBn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-06 at 12:11 +0300, Tomas Winkler wrote:
> On Tue, May 6, 2008 at 12:09 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> > On Mon, May 5, 2008 at 5:22 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> >  > From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> >  >
> >  >  This patch maps A-MPDU HW queue to mac80211 SW queue scheme (as int=
roduced
> >  >  in patch "mac80211: QoS related cleanups"), when trying to perform
> >  >  ieee80211_wake_queue.
> >  >
> >  >  Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> >  >
> >
> >  Is this going to make it to 2.6.26?
> >  Without this it will be hard to run 5000 under 2.6.26 as is.
>=20
> I meant 'QoS related cleanups'

Oh. No, I don't think so, unless you can somehow sell it to Linus as a
bugfix ;)

Disable the 5000 in that kernel and make people use compat?

johannes

--=-0VauDyUhEheDM74yUYBn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCAm/6Vg1VMiehFYAQL2ug//bzhJO5Vf+6qlHT6me1qUy/Dt/D2/fSE6
xj28q+ume25ZkTjaTENcF1RccXzX0IdndPra3emQ3icqjpbAdAqSOMBHEJi+Qtyz
KIZl5EOxwgIpwYmRhWbfJlbyFW6SfcDNuCvRDzomI5kjalVx3PJBcepRVN9kdIMY
WzDrltA1mzV6jjEyP9BkZq7k1ysyAqIi1wVM7xZj/860BvTkxczhVFLkDeZccdmr
qmR1wsP4r6mdLBhBsAz7/Zei7id279Ofmy9mnFVeE85emb6/VV7RmTmsaDw4XLmp
aluKzLmXB7xk20r/pXnfqh7f6/7xl6UsuFJf9FwcKNkMlYWwvLd7LZUIZnXzB2s6
VV1R4Te7bHqH/01EnFqBzPU8+draJQa/Wfa+XJk/gfJz42iDxfb8B/vJTM04mrqC
v9BONRUh08N708GjiIX4ULpLsuS+zsWoJc5YXcuKbCFwC5lAr5nH6yAPi9YCT1hz
xFYV4099TpyYRlRyzHfvaRIj5/D5xk4KU1WeLo4Y3TLOhmJZO2UhONaOWQ9k+TGN
j2WwydKG0vMqkFc3pc40YM8RNQxhSJ70XeDMoe1XNdupjEMb80Cu12+I3UhFxqeT
2Y0hC0nLASOthHkmadr2VbMm/7x1yybPy30wdfyuAgrA68cN1F8SMr2RYsq55Zl/
cjUhPD0LO14=
=m1Cs
-----END PGP SIGNATURE-----

--=-0VauDyUhEheDM74yUYBn--

