Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbYFLUyf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 16:54:35 -0400
Subject: Re: [PATCH 1/1] mac80211: fix beacon interval value
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806121347x211af015w51a9ca3cabaac96c@mail.gmail.com> (sfid-20080612_224749_666575_3A188782)
References: <1213299517-24042-1-git-send-email-tomas.winkler@intel.com>
	 <1213299706.3730.39.camel@johannes.berg>
	 <1ba2fa240806121305h721c6bd2x8073660d41653b92@mail.gmail.com>
	 <1213301313.3730.47.camel@johannes.berg>
	 <1ba2fa240806121347x211af015w51a9ca3cabaac96c@mail.gmail.com>
	 (sfid-20080612_224749_666575_3A188782)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3mVuVniqh2YvwdIA8lpM"
Date: Thu, 12 Jun 2008 22:53:56 +0200
Message-Id: <1213304036.3730.51.camel@johannes.berg> (sfid-20080612_225438_535659_D44182F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3mVuVniqh2YvwdIA8lpM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I don't see how the beacon interval has any relation to "what is best
> > for the hardware/driver".
>=20
> Usually this affect power management if implemented.

Hmm, yeah, but wouldn't that have to deal with all values?

>  And doing this just creates hard to debug
> > differences between drivers. All differences between different drivers
> > are causing problems at some point.
>=20
> Get assimilated :)

Heh.

> > Wrt. configurability, yes, we should maybe allow this. Although it's
> > only used for IBSS (in BSS it is configurable already)
> You mean probably AP

Yes.

> What should be the proper interface  sysfs or iw(nl) ?

nl80211, I'd think, yeah, for BSS (AP) you can set it along with the
beacon.

> >so I'm not
> > entirely sure... users are probably not able to make an informed
> > decision anyway.
>=20
> Are you talking about Linux users ? :). Usually vendors take such decisio=
ns.

Well I mean if it's userspace-configurable.

johannes

--=-3mVuVniqh2YvwdIA8lpM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUYzgAAoJEKVg1VMiehFYPQoP/Al0GWFzGkWKSEQDs3U9ZB1t
zKfSHkNTueol690qiAoZLl4LSmUU54TRZ5W+5PvHst5La64/fLJ85WYFuIdiZn2J
fU1gmEWY4n0Lqt3Hn1f5dzYPiIFfD2b2J4J1FTRmvTX4l3lKiKohXFIgnxjc7dfG
ZN+Mjron0MpMMUvcVpuM/CvcDH2OxD91aoO8OwY659jrB2wryzCoqDRUQTDtTrfX
jkLGdK3f+VGbGtUNL+ofxbevmVStC357OHX1LOTcWFhsQM6rKxAL3YdjqreX/GGc
L6U+yi22+WqqAbJhvNfu6T/oGw8OkltmYuuBpjdG/p6lktUgCE48wGR+PU8wYE8L
xnff48+nytVYYfZJfdYmlr2aOLuVx/NiiThStCKi4Kh1Xo6agY/ixSJKa0+KxgCR
xMruI9A3dTpNvcatw1Pt3K2me7QY+C16IfFz0ZiNYEPVXMg/0xPJ4RTn+G6KdMkR
cIQ3nBBzEF/6NmEUzXlugZMqvDwg169NqrXyEpM3m4u7fKrrrvc0YVIi0T+vaMJd
tfsSiII9c4yBl547ig6a+VhMUE7u7fGvAqwCruGp5a8NvrsbZSj8tTiUHXZFSFAL
ZZ3Vi74E8sDjl2/VXURNIWWCxqJAx56th2KxhRdj1FWsCoj6NyLnjG8YaBdwAXy/
IBUuLsjuJ1QbPxocx4rV
=3nFP
-----END PGP SIGNATURE-----

--=-3mVuVniqh2YvwdIA8lpM--

