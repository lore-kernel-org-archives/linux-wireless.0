Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37604 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYIHJCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 05:02:35 -0400
Subject: Re: [RFC PATCH 1/3] mac80211: restructure disassoc/deauth flows
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809080155m48910922sae4f45ab0d7b3888@mail.gmail.com> (sfid-20080908_105539_851637_A8AA20D0)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220739259-16918-2-git-send-email-tomas.winkler@intel.com>
	 <1220862200.31304.24.camel@johannes.berg>
	 <1ba2fa240809080155m48910922sae4f45ab0d7b3888@mail.gmail.com>
	 (sfid-20080908_105539_851637_A8AA20D0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lHxBiNNIsKD/ox96jl7Q"
Date: Mon, 08 Sep 2008 11:02:29 +0200
Message-Id: <1220864549.31304.41.camel@johannes.berg> (sfid-20080908_110237_981956_EE273D2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lHxBiNNIsKD/ox96jl7Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 11:55 +0300, Tomas Winkler wrote:

> > @@ -1084,7 +1114,6 @@ static void ieee80211_associated(struct
> >                                       "range\n",
> >                                       sdata->dev->name, print_mac(mac, =
ifsta->bssid));
> >                                disassoc =3D 1;
> > -                               sta_info_unlink(&sta);
> >                        } else
> >                                ieee80211_send_probe_req(sdata, ifsta->b=
ssid,
> >                                                         local->scan_ssi=
d,
> >
> Yep
> This is rebasing bug. This line is newer than the original patch.
> I will added this hunk.

Alright. I already have it in my version but since I've rebased my
patches on top of these three anyway, you can simply send them in when
you've verified that they're ok (maybe with the queue stop I just sent
you) and then I'll do mine after. I have a few I'll be re-sending but
they don't conflict.

johannes

--=-lHxBiNNIsKD/ox96jl7Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxOohAAoJEKVg1VMiehFYDhcP/R663CL6IYHtvJBbkadt9Oaw
jATgDuHWp9x4Nwuj0kj6Y5ZmYqyWfxYbgTViUEXGGskObiARYhUtYryMJarjVB5n
t7tGV6LzBdB1aM6RnqpIeKUkG403xr58l3S6+qjlTDf1wbvSST/z+I8UHyHez92r
32eIF2hDq6HYaeNeHtBnnav1E2Ioome7CBiBislHtNw4htAW/sTOtLXOnKd3VuhQ
c4yH53BEl+vtqQSAqz0V6HjU4WS1UcO5z86OvAQnGqylyaXwIirJKWhm0+rnZe10
9XDOv/tci8KhQtnrE+djS1L7GOxFS2kp8ynT796tWG0LWFkSpfRdHuqcnUAPnORq
HO8F98T/BXK/k7DbPppKNiWeuITcv3JuMP5XOiy5a+pH5fKFRW/53GYfpm5IYOtd
e2PYCtSdhwljHI2vX7Y7umfdzK8bAjrJ/zsuk02cZP5Lh4ajhHOrhjb8HX+TeH9q
CEVwOSSLsZLNlm25zH0H8SpQ/R5BAYqdCBaHimRXYHoPbM3snN2+mJyufQxj0mw2
qlrwiVkTQ50PWr+KT3eGsgY6Kyz5nQo0nPhWUkXrMuAdmdm8uVq5tN/NBnEsNLGM
GWmiOoszt+DEbns9h1I/RyGabdlMujDoVIMCvT0Xs9WA19bpW0rJbbqbMaAH0X3M
dZgQXTsWWlr0932saziG
=3l3N
-----END PGP SIGNATURE-----

--=-lHxBiNNIsKD/ox96jl7Q--

