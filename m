Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYKTGpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 01:45:17 -0500
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Rami Rosen <ramirose@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kune@deine-taler.de" <kune@deine-taler.de>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <20081119211826.GJ3485@tuxdriver.com>
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 <1226943608.3902.36.camel@johannes.berg>
	 <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com>
	 <1227106146.26243.43.camel@johannes.berg>
	 <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com>
	 <1227107869.26243.52.camel@johannes.berg>
	 <20081119160135.GB3485@tuxdriver.com>
	 <1227126620.26243.71.camel@johannes.berg> <20081119210046.GC5900@tesla>
	 <20081119211826.GJ3485@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BRb76VyVonIGQ0MGgHNZ"
Date: Thu, 20 Nov 2008 07:37:32 +0100
Message-Id: <1227163052.17336.7.camel@johannes.berg> (sfid-20081120_074526_592081_47E4DAC2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BRb76VyVonIGQ0MGgHNZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 16:18 -0500, John W. Linville wrote:

> > How about making it Kconfigable for broken AP support and add the
> > warning there?
>=20
> That doesn't really associate the bad behavior with specific drivers.
> Probably better to send something do dmesg and/or make hostap aware
> of the issue.

Indeed. It also doesn't help you when you're sitting on a train, IBSS
mode isn't working and you need to exchange information with some other
device :) Mind you, normal users would need to have NM support for APs
anyway...

> Any idea if many STAs are smart enough to stop going to sleep once
> (or if) they realize they are missing frames?

They barely have a chance to tell the difference between that and just
regular packet loss, so I doubt any are. mac80211 certainly wouldn't be,
and I don't see how to program such a thing easily.

johannes

--=-BRb76VyVonIGQ0MGgHNZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJQWoAAoJEKVg1VMiehFYdF0P/327tKQykdgLBc7apQUMx0r5
me+3zaxzkmFk1oxjGg2/8aweP4MXtq57xensD7CWpgb6+K+Yij8WCQqAvembdjGL
/fViWewEGBMrzfJnvN1U0r6bqMevsk95Y62lge1SdqM5/58wFLeI4Eu9fu4Ee1DM
eYIJUHhr6D9PiHmbAe/3G0O2amw6hDUVyuU+3wzMRmFDeEBW6ZT4jk4B7nI28beL
8qty9dttpenU5jc4VoR48JLYY/OtbA4crNDU8wmeaqxQvc38RiR2rxIOB6Kd/8rr
vI8XgdrGzTEDXEEUeqdOsyT+kYWO3S0Z9f7SlGmivB5FeSiOAyLze0V6wtjgsdxz
5RdTtplf4xBLF9gqbsPDM5Rig8p/2BZSz/0bSSJzM3srmCNkSLzTJmyBhwL7Nq04
RoeURMEnNVpzqMjB5pcrJ8p6F2SLm3+wdCRzEnBZuMvBTk/c/p8FKR7pvSuLlZep
1NkVRgxp9a6Crg23BQkoFbDFW1kynTQF65otnlw/60UDFq0YAh2/Iv+sDSCdMt58
LUO70BYiXzl/o96L9c1l/Li2m3KSkNpa0Cz8kYSBlHnT4wfDK6CSDmwZVIm4mSN7
rbK6GHc9NBAYdRRnWK+rSALpM9by9S15Aben2tQ0ey5/r2jSbfUZ8bpD4HwcFzdT
3+o7IFVAJvS/Nw7rM0PN
=xVpS
-----END PGP SIGNATURE-----

--=-BRb76VyVonIGQ0MGgHNZ--

