Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZFTNOk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 09:14:40 -0400
Subject: Re: Question about rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A3CDD2A.1060505@lwfinger.net>
References: <4A3C5D49.2000106@lwfinger.net>
	 <1245497653.16399.27.camel@johannes.local>  <4A3CDD2A.1060505@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AYnyZ3KEVsJtE0A24ZkJ"
Date: Sat, 20 Jun 2009 15:14:38 +0200
Message-Id: <1245503678.16399.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AYnyZ3KEVsJtE0A24ZkJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-20 at 07:59 -0500, Larry Finger wrote:
> Johannes,
>=20
> > No need, radio_enabled is intended to be removed, because if you rfkill
> > now cfg80211 will force the interfaces down. Some time later way may
> > need to add a way to disable just the radio again, but that will be
> > different and for different purposes.
>=20
> In b43/b43legacy, the driver can determine when the hw has required an
> rfkill, but what is the "approved" method for determining if userspace
> has killed it?

That isn't necessary. In that case, cfg80211 notices that it was killed,
and (via mac80211) ends up calling the ->stop() callback.

johannes

--=-AYnyZ3KEVsJtE0A24ZkJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKPOC5AAoJEODzc/N7+QmanTEP/0OnN2VSb6/zjMPp2cDjgGHo
G52NrJbg3idlZ2lbGkMqVpT5SCXX8zxQPDnjwVFRSyCCavKRCFt7q0x2aXKUZCwk
tKfj42xhzsKZVTwWqjVbWOYTPG65Z0cPaTpx1MlAZt989CEnDKkVX5YUVkZ2IE0y
etESu//kKOhaurrLYayJzc1keAmNMeZ65olSuh+MuEjZc0qRqFcEYrpbD1urnXrd
jd2mvzzXWOuaNDbinLhsNHUa9LEzmrYay4mWCFE5c9Em9UL4d12R5dfXGhxDxxMY
MM7yaDfca95JLirU0IdNRrtzHzZf0GwNobsN6U8+NMxENKXkTrsPgt3+x6ZZgLNS
mSHEGwgokZ1qD1OTDpN2nT963v5xCT18Hfq03ORCXOCQyviSj+smPQvH47T1lhls
GlZnSAoYv/fTvvVwJFK5CluRcWWZBETWmiQ8M1T/5JxlAA+sB2K9laSkpin4lrcu
lEfknaxwCM607VvobuxaojzfPjHMkGorJnWnKCEwMC+w/rV2kEk3fRdg79dfxZfq
/jObAcJ0KQme/oJDTFpUvMp/NlHqj0AJbcOBxcIZaKJZ07iiF+n/4I/6NNoMMKgc
tghA3rcqi8S84/kCVWW7mC+9DUu11ZSYci7VqLun22LJhdSRMowRRUV5TeaO2QSV
FHyOnWGrdODGZEMin9FN
=lrqh
-----END PGP SIGNATURE-----

--=-AYnyZ3KEVsJtE0A24ZkJ--

