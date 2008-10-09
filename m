Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYJIJkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 05:40:05 -0400
Subject: Re: [PATCH ] mac80211: fix wrong link typo in mac80211_hwsim
	documentation.
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>, Rami Rosen <ramirose@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081008200334.GE32472@tuxdriver.com>
References: <eb3ff54b0810080243r416b8413uf2e12f51c309a8b7@mail.gmail.com>
	 <1223459201.3618.49.camel@johannes.berg> <20081008161834.GL4941@jm.kir.nu>
	 <20081008190109.GC32472@tuxdriver.com> <20081008193754.GM4941@jm.kir.nu>
	 <20081008200334.GE32472@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jpse51gpsTEUhPWnQsSy"
Date: Thu, 09 Oct 2008 11:39:59 +0200
Message-Id: <1223545199.22490.5.camel@johannes.berg> (sfid-20081009_114010_525834_C1B7658F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jpse51gpsTEUhPWnQsSy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-08 at 16:03 -0400, John W. Linville wrote:
> On Wed, Oct 08, 2008 at 10:37:54PM +0300, Jouni Malinen wrote:
> > On Wed, Oct 08, 2008 at 03:01:09PM -0400, John W. Linville wrote:
> >=20
> > > Well I might be OK with that -- but are you (and Johannes) ready
> > > to deal with the various "ap mode doesn't work with my hostapd
> > > configuration" problems?
> >=20
> > I think that that is a better and more productive problem to handle
> > assuming the issues are indeed because of something missing from
> > cfg80211 configuration. I'm supposed to make sure that everything neede=
d
> > is there anyway and getting additional people testing various
> > combinations and reporting potential problems sounds useful.
>=20
> I'm inclined to agree.  I'd like it if Johannes agreed too. :-)

I'd hate shipping it when there are still things to work out; how about
we put it into -testing but not into -next? I just looked at the list
and we still have
  * basic rate set
  * tx queue params

left to do.

johannes

--=-jpse51gpsTEUhPWnQsSy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7dFqAAoJEKVg1VMiehFYzmIQALCR2KWAGARTM6XrM3PLtAG3
qp6KB/y1wPiaqunvblJWuqvx0P9MCk1lhNb/lr2+MuZhmjPIdq//SfWOMw4tFhsZ
w7F6G0X5EBgzUaAad1BZCvUye3RrIjXnlc/4FgDPTLFNNishFIgQWSPZ8Lxncdp7
EvSdP8qHnHtHpzqfzdecqGYRNHkCCbyHxx/nTlx3Cv7OKcyQsDU53DZOmtcXEeAf
v7VCTKz0MRfK7oUqOJWKzcW6ZQM5GV8rUoApLp4B4PdRwE1PLRppTTozEbWWBd4c
a/100gGdt3jhrDAdQtjf3lUd0gGB4FuQVS9Ab6YOdlMhRE68nobNWGQt+L4wgF7A
5PFfLc3lqCP00UJUab8khpmRqjsoZvBJv7qupvgvCTdT8/Vrw57n7VeThYSBVXxL
uqJZdPaupRR5W1pKTs6PhZ5Zvini4WsQ4on6O5MJASllLDNCzdos+AbAG7Y13tuW
T0Gh+XDIjlVkujC3AGcU7cdr3dYTUVizjS0dpaDcRzM5exDRV1Mvfd2DkEjD8I+v
QvgPBeosuZ0t0fF8IpdXUR2+47SEUzwk5ApLuX88TpiHtnzosIM4aqIrYaaPALp4
RxrGPH8gb7AA0E5d6T4+OjoyRIGBTfl7odsiCNu2VjRf9bUVv1RSPnMdvJj2I/3r
RjHUfBH0CUWuGkPQtYrT
=Xw+p
-----END PGP SIGNATURE-----

--=-jpse51gpsTEUhPWnQsSy--

