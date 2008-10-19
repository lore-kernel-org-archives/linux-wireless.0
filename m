Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39068 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYJSStn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 14:49:43 -0400
Subject: Re: Power saving on mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <87myh0a1zd.fsf@nokia.com>
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	 <87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	 <1224412006.6324.45.camel@johannes.berg> <871vyc7st7.fsf@nokia.com>
	 <1224434885.6324.49.camel@johannes.berg>  <87myh0a1zd.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CQEk5yV6r4Fc2U0nX5MI"
Date: Sun, 19 Oct 2008 20:49:36 +0200
Message-Id: <1224442176.6324.53.camel@johannes.berg> (sfid-20081019_204955_175896_B71C0F38)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CQEk5yV6r4Fc2U0nX5MI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 21:12 +0300, Kalle Valo wrote:

> > It seems to be a firmware feature, first beacon from the BSS the
> > firmware computes the checksum, and if it changes it lets the beacon go
> > through and re-computes the checksum, so you see all beacon changes.
>=20
> So the driver doesn't have to compute any checksums itself? That makes
> things easy then.

=46rom what I'm reading in the firmware docs, no.

> > Maybe it excludes the TIM.
>=20
> It should. Otherwise beacon filtering in a crowded network with
> clients in PSM would be next to useless. And I didn't see any major
> increase in power consumption at Maemo Summit :)

Indeed :)

> > I think we want this for when the QoS parameters or something else
> > changes.
>=20
> Yeah. Just out of curiosity, are there any other parameters which
> mac80211 needs to follow? Short preamble? Short slot time? Anything
> else?

I think that's about it. Maybe something else in IBSS, if that works
there at all.

johannes

--=-CQEk5yV6r4Fc2U0nX5MI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+4E8AAoJEKVg1VMiehFYHtMP/iUCsiuCBzNpdhepBAtBRFAQ
/mdNBsvbnskZ1rFUjWevXxh04Zv9NvXP/lpxBP3kegvgD9OjrzXczGL11g2VSfCq
tFhD2/8hhTHBj3IwFY21uIZEP6B251xQg23aYqoWuyw765UMprxo+2yEQC3kdBjl
QWNAYcaVtZyo23nlTSAVZAqPOTKo7UMmRBlaqUMaCA/S+tFmidSxXm/hP1iwfM4Z
Xx9LIUj+eSW3cJHLyrJdMtP6Lh97TvPd3h0R7GR4UzzHEXtgWtdPSjyInEDPnBFj
Tweu0tiw5VmYtsFwZPvuuQ1s6wPahGGb+4FgovcAY2RYk7GpnXLQQ5EML+FsjsrO
ogCm97G9TvpnGh9/rFj2tovrAIwk/hNLEvEr6Gr8Z478pgjPmLAmC2GNVPkdLHdd
RQz8TPLEit+J1K+dUGN4luKkpilKcgXCCPUbWzdp5v95mIWqhp+rmdsIdK0r+t64
TZlPqXJM7svTTYJRW48WwfvNGWC+5CCUoRWpVD24Zd4VxLZQ/lKN/JWWCrAm1ItO
dCUFZ1W1bl+RvttXn0ojVe6tyA8IvMeIzvwTwrB/RcXdgjay+vBTNjcFSDZexLcx
HUIBA444g0cNJvDJKlvarOE8uVoVcBJqhZvhdUqM1vBCaNNfMviy4l+brX5mu/pV
3msfRxIbkVmZDrb5dPaH
=nsXh
-----END PGP SIGNATURE-----

--=-CQEk5yV6r4Fc2U0nX5MI--

