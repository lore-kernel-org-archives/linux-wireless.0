Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbZELRyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 13:54:16 -0400
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200905121856.02714.chunkeey@web.de>
References: <200905120109.09906.chunkeey@web.de>
	 <1242142227.4331.7.camel@johannes.local>
	 <20090512154116.M40327@bobcopeland.com>
	 <200905121856.02714.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mZEgdc45HIy+W3n1iM86"
Date: Tue, 12 May 2009 19:51:30 +0200
Message-Id: <1242150690.8403.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mZEgdc45HIy+W3n1iM86
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 18:56 +0200, Christian Lamparter wrote:
> On Tuesday 12 May 2009 17:56:10 Bob Copeland wrote:
> > On Tue, 12 May 2009 17:30:27 +0200, Johannes Berg wrote
> > > On Tue, 2009-05-12 at 11:29 -0400, Bob Copeland wrote:
> > > > Will pre-scan be called once per scan or once for every channel swi=
tch?
> > > > If the former, I think it's not the right place to flush.
> > >=20
> > > The former.
> >=20
> > Hmm, nevermind, it should work.  I was thinking of queued tx status=20
> > work not being on the right channel, but I guess we don't do that for p=
robe
> > requests.
> Ermm? wait... what do we do when the userspace does channel switch & scan=
s?
> I think, some aircrack tools actually do this. Will they also call pre_sc=
an?

No, of course not, but there's no expectation that TX is somehow
synchronised with channel changes.

johannes

--=-mZEgdc45HIy+W3n1iM86
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCbceAAoJEODzc/N7+QmalycP/1MXfJpH6j2u5ZVQjsaEOzOp
vSyjvzFo+voju96ubZf2frjsGITNLpZ2nCCQuoagFn0lHSvqcoS8hq0t5UniqXN6
biToLq7IEOYSdL6sXLr6f/Hj0Nt11nJmL093z+XRGQlcyj/o8U/InIYLhGPLoytI
9Sm8MEjeNSzS54YaUVoZ0N3j+pwGAjSMkfCmEELHSVY2EPxRz7E1u45685ydTqtt
VGEv9cved4bqvXtrHFcBV4hP2g1jjCKaJFajFUFBSQ0PW5U41QmbpI2S7BWzF5TD
cpDOtkpSLUTgrKCK7KimQXS6LgKGtapNnhtSJKKiyfgOAARjFJ7MgltzJ8UWAp/K
lgNA+9Kfl4lgj2PRwS6kYQd1+jsOra1TlfQuI9rKwKxPuHlsepbuc1iKe1PWEmxt
7s0RzxHhL3BaOyQ5M4eCo3oxsbD3TN3iejy0gnSY7E/vvxsRJ/i6oOZdMAOmgaw1
sEMIqwse16OqL7S+ZAiyogKWG1fPE3SbSZW7vSZiGzM8aHXcjthaQ2HSbqpBwBev
u1o2VrSidQTqw9AHyvOCz5mE0F0mWhOIEUy/9Mv6+OsIB7Vtu5f+HpuTGhFho1Tv
3UVhadaIPNAz/iCpRoMIB5P6G1ZcugCbP9Kuew7gmdMKMt+xubz9RUIAQCUW8oQ4
MR6sy2lbaEYfDzOusH3f
=m/dT
-----END PGP SIGNATURE-----

--=-mZEgdc45HIy+W3n1iM86--

