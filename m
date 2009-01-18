Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42989 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934101AbZARRN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 12:13:58 -0500
Subject: Re: [PATCH 07/13] cfg80211: only export disable flag on channel
	disablement
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090118153004.GS29609@tesla>
References: <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-5-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-6-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-7-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-8-git-send-email-lrodriguez@atheros.com>
	 <1232097827.3854.25.camel@johannes> <20090116163245.GF29609@tesla>
	 <1232138101.3745.7.camel@johannes> <20090116210930.GL29609@tesla>
	 <1232268516.3877.10.camel@johannes>  <20090118153004.GS29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QeywfzICoZTA5rhtD9n5"
Date: Sun, 18 Jan 2009 18:13:51 +0100
Message-Id: <1232298832.3819.7.camel@johannes> (sfid-20090118_181418_968279_00437819)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QeywfzICoZTA5rhtD9n5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-01-18 at 07:30 -0800, Luis R. Rodriguez wrote:
> On Sun, Jan 18, 2009 at 12:48:36AM -0800, Johannes Berg wrote:
> > On Fri, 2009-01-16 at 13:09 -0800, Luis R. Rodriguez wrote:
> >=20
> > > I can put a note, if that helps, or are you strongly opposed to this?=
 :)
> > > Just an itch to scratch really, have you seen the output of iwlist on
> > > disabled channels? It can get long on radar/no-ibss channels. We can =
also
> > > handle this in userspace but seems pointles if the channels is disabl=
ed.
> >=20
> > Well, come to think of it, at least for programmers it might be
> > confusing when they know they've put some flag into orig_flags, and the=
n
> > it disappears? I'm not really _strongly_ opposed to this, but I really
> > just don't see the point :)
>=20
> Have you bothered calling iw list with a long list of crap on the channel=
s?

Heh, no, but I rarely call iw at all. I just added a patch to iw to
suppress it instead, I think that's more appropriate.

johannes

--=-QeywfzICoZTA5rhtD9n5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJc2NNAAoJEKVg1VMiehFYapYQAJp6EXdpuY41Tm3FD4LCDsEZ
TRVBTUS7Fgd48V8OrUHIDQbg87MVO9WZhaKoMXasQAkEGP82IC9eo84U+wqRF2SY
g+XVa+BaZkJdYK/zJf9Y/EciK/KGQ1BPAqzzZVp8VNC6ncVl+oc/ZNe/zSEEqPVW
YZ6J8k5rtSBJNE4BiH6OROAeZUxlcMCc5ctlcAVdKA7f1HDhuqRMNtl6dc0jmCfG
9LpSXyB1FkrAI0Ap61392LCc9tREgNqYpTgKJKaeT1HAC/lwnPXvPDNZSGmwmjzl
NTa34KGSN7QmSZRHfN0N+aZjFbrBkOMuBZfKem92PyuMsLpORTEoiV+AeBK86BvI
qe7I5fNvt47O2uu9F8m1ux0ntQgRc/xIfjrwO3jGpZzp9C4Z8lNUcu+idxFTby3f
n8XrmdHTpNaFbMwgx/FPywlMEkhZHIH2/+Lem13fvzsFV96atwHH75AhIAE87jQJ
Be57yyxi/jSH/Wxmce2HOVfNa2GxFvkP2+EzN3SQrEK+VZvQIsPsoTMOwQf+IaiX
mjJ2/FJZ0H3d1QYCjdMj4nIBn9wXeQl0L7GkX900PSHifTQidWGIzJ4nnaqxi0yJ
XYxe3+2QrWmk/trbrKMe3hL0vBpR/4QL7mqrPuY4BsNEf6cBe2+2nKrxYpguKBvc
3V7SIxUBvX6hPN877LPH
=JtJ2
-----END PGP SIGNATURE-----

--=-QeywfzICoZTA5rhtD9n5--

