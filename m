Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498AbZCUIC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 04:02:29 -0400
Subject: Re: [PATCH v4 3/6] mac80211: check if HT40+/- is allowed before
 sending assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090320142957.GA8120@tesla>
References: <1237444886-24530-1-git-send-email-lrodriguez@atheros.com>
	 <1237546136.5100.147.camel@johannes.local>  <20090320142957.GA8120@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7803FRsval1j/4bznJom"
Date: Sat, 21 Mar 2009 09:02:22 +0100
Message-Id: <1237622542.5100.163.camel@johannes.local> (sfid-20090321_090234_587557_50F1F921)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7803FRsval1j/4bznJom
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-20 at 07:29 -0700, Luis R. Rodriguez wrote:
> On Fri, Mar 20, 2009 at 03:48:56AM -0700, Johannes Berg wrote:
> > On Thu, 2009-03-19 at 02:41 -0400, Luis R. Rodriguez wrote:
> > > We weren't checking this at all.
> >=20
> > The question is whether we really want that. In other places, we trust
> > the AP, why not here as well?
>=20
> Its not about trust its also about if it will logistically make sense, fo=
r
> example you simply cannot use HT40- on channel 11 if yuo don't have
> a channel 7. The NO_HT40- would indicate this to us so we don't bother.
> The example I give is lousy as its not something that would occur usually
> but with 5 GHz and regulatory rules changing things could be a bit
> different.

Yeah, good point. That's why we need to disassoc from the AP if we
definitely cannot support it -- we cannot change the APs opinion of our
HT40 capabilities. Of course, when we start out not supporting it we can
tell it we don't do HT40.

johannes

--=-7803FRsval1j/4bznJom
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxJ8LAAoJEKVg1VMiehFY9YcP/R3f0UIjlC37stU8XwY5EXN/
hyINyz2gSy65SbNlM6TqEO4y9wAPQD+vdyRsYnP2yiRPCB3LVeQug8HEgDoVjVwi
e+Ql7IgjasWeTDckrdLEcNo94W/906MyQIDrtXf9czEBJYRi5gcggHxVfS4MCHTO
VlQ9sSrnw8fJPLg3OAg5zocrgOpRA21yuEEGuoKQ3ITjBIQU6EWwc2vhcfeV7qdg
276JkD8aQunt2ff/Br5KCFY0StMRSNW5JtPqbyNcQSPs+Ll8rxONGkyjrSMb3P4M
Z62fa9zN1it0q0VGVonjNEc5afG8i2kzmJ+ll+zZQHVvAMXlxDEgwTn7Cq99kLa8
H6cRG5LYmQi5CigO1pfE/6NpuSu2d0GGfqXPGFM2K92urNbjnezWTvlH5UB55MB9
KckB8o2U+Sv6xVWkWJ4win1Y9KSA1Shbree7X6jeTGOZbPz5WwQSpxJXIosDxbZ3
/zi25fURx8eW+18CoHXFOyOLuDg4LAvb619YAz5uX4tPjt0tmZ60VS/2Lx9rz4yZ
SVSlFMdI49CL/Ocn/cDvYpL5GoOX+yxfiGV4g2NzEqUIqHXYw9Y6bNPA1nF9QgI5
qpDDsAq8u1IloR5kEItzKdzyR282NI/shc3d/XqUq2ufJpEKoA4rVLRtM0R0lV6g
5qqFFUdCqB3gP3T0v4oh
=WOqt
-----END PGP SIGNATURE-----

--=-7803FRsval1j/4bznJom--

