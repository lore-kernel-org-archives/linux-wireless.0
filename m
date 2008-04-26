Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYDZRzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 13:55:09 -0400
Subject: Re: HT info in probe requests?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240804261012v1702e33fmf863e8189809392d@mail.gmail.com> (sfid-20080426_191256_773286_AA2D7F19)
References: <1209049768.10943.3.camel@johannes.berg>
	 <1ba2fa240804261012v1702e33fmf863e8189809392d@mail.gmail.com>
	 (sfid-20080426_191256_773286_AA2D7F19)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kcH5Rh3pnTW6gcOFsHrF"
Date: Sat, 26 Apr 2008 19:54:59 +0200
Message-Id: <1209232499.10943.55.camel@johannes.berg> (sfid-20080426_195529_074418_04B23255)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kcH5Rh3pnTW6gcOFsHrF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-04-26 at 20:12 +0300, Tomas Winkler wrote:
> On Thu, Apr 24, 2008 at 6:09 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Hi,
> >
> >  I just found code in iwl4965 to add HT info to probe requests, shouldn=
't
> >  that also be in mac80211?
> >
> >  Since the probe request building code in =EF=BB=BFieee80211_send_probe=
_req and
> >  iwl4965_fill_probe_req are pretty much equivalent, shouldn't we refact=
or
> >  =EF=BB=BFieee80211_send_probe_req, export it the probe request buildin=
g function
> >  and make iwlwifi use it?
> >
> Sounds good to me, but there are little quirks as iwlwifi supports
> scanning with multiple SSIDs in probe
> I would like to very much preserve. This speeds up scanning
> significantly. Hopefully it will be utilized in nl80211.

Can you actually give multiple SSIDs in a probe request though? I
wouldn't think so so you'd just have to give multiple SSIDs to the hw
scan function.

johannes

--=-kcH5Rh3pnTW6gcOFsHrF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBNscqVg1VMiehFYAQLCjw/5AZ3NcDOYIMJd1ayY11OZzXV8Kffe9ouQ
iDih1xTWWR+2zg9hteOUuw+81Toi0cgSzFtU1A1g8iZOxn5TVujpAzJUtYfEW8m/
2EFPGXGpZ/NJOJwfhWdTmsuMyY3LgZ1sCqcO2FGRhJBOOXxbKNVQB4HF3XaN5evt
Bz1zs/Njuruv5Rx/VAOWBzIqlZy/FjqJRB+QYB9Gs6SyGu+OE5IdNMNdlCKAokUo
5p6gpO+1sDGlnse8a9geQGet+pBrRftYr/Bf4cKocC/r3Ctw985yMPCNP9MIJV8n
pHcfdxts7lgkroRis7p/crOTuePZHbkReqDVCO9l8U5JdmUfk7DxMer7vEwVgn3M
5gfTRK59g55SlrC8tM3N9oE5Hibbl3nZY4t8SSeUPQryAR4vnpjrP39eBeAZECh/
qpJY2y0NCaXGlFizfQ8cJKrAx+6SGAEyIbTeYD/O+7qLR6M7BfOMzGyv+GgPQCGB
f7AN2VnjoGyJncEIAMsKDo4xxGP/XhtsjxO0OV09uutFTdFLc7jcZ79a2XgylXnL
f3rMXHFuOxZ+ShfEQhi0G0KrwUYvfBrY0aI57Fey2HuaNNDuvLXdZsuvoL0hQk4Z
EkXKOQq83ZO12Nnw7vy5DBmJuSrbU3A1rqIGpDDi4DEGsVS9NNAJGMsQtD+8aoQM
24UvxxF8v+Y=
=u3DR
-----END PGP SIGNATURE-----

--=-kcH5Rh3pnTW6gcOFsHrF--

