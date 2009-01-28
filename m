Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZA1StW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 13:49:22 -0500
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LgzA/NQANRqTbnY+cAaV"
Date: Wed, 28 Jan 2009 19:25:51 +0100
Message-Id: <1233167151.4811.11.camel@johannes.local> (sfid-20090128_194926_801209_B5CA8D6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LgzA/NQANRqTbnY+cAaV
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

I tried, but that didn't work at all. Would be easier to recreate the
patch from scratch...

johannes

--=-LgzA/NQANRqTbnY+cAaV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgKMsAAoJEKVg1VMiehFYovwP/3OmWsixtkHuRL9kVPL9KqNx
Cj4D34sg0pxEagbftshm0OjlflYzaIGDSGkO93kAZ/ILxVkaPt/ZNVxpCxRNQ1W/
p8s924ORHnBuSY8n1MR8JNImGWfQfZx3rFn5fAT2CiAsbPEuvseuMrs2qVDg/ZwN
PFCMRCLt3u9p//GOmUXQQf+3R/cz8JkcaEIloDe/NvKjA5RCwx7Jkb4JVA+2tjDL
pPjQ2Czk/2JNWLpQeIwI+5M5Nzn9Ad2jNzMG6W7eIAyqGW9zB1bIRN4GkYzRRfIq
lyzlxInKpbBA7rjUND2wrfJaCxAeApHy3sfzxcG16N2idaRa245wyq/Vde5tx0Mw
a3wId3liVLZK+3cnAT0SBCUEOKGn0uYVhDBiiMLDXlb5mNpnqCL3KxXQYHZah1k6
zbqD22vC8ZGosh6J1UYblz5VoRQ9z3mCYzcxHFVpSZZHiTP5kFfjzsLiyQS6UgnX
9NjGbEATaOoSIlcowWzNxY0+pE2nqMXMIUeAbGO4mGD0QK632vvIuGuYJoyk1Cw/
9OkLfIp7U+zEIjWPT9/p1G8FVGGtIvAbKhW8+ILXwYbfjZTq1AQu2Ey0guap0DDr
W7uiQCidNBL+NT+fmEC51v6765fSIlDGPJInRa+fTKu7cQCSS2Nr6r44T+1EMQ3U
Efmda2RTRVfUi4iyVW/e
=iTHI
-----END PGP SIGNATURE-----

--=-LgzA/NQANRqTbnY+cAaV--

