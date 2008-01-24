Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYAXP6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 10:58:33 -0500
Subject: Re: [RFC] mac80211: proper short-slot handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Yanbo Li <dreamfly281@gmail.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Daniel Drake <dsd@gentoo.org>
In-Reply-To: <1ba2fa240801240717y35ed36bdjd5399f00dd73d687@mail.gmail.com> (sfid-20080124_151759_169747_479A8ACB)
References: <1199974496.3861.80.camel@johannes.berg>
	 <200801161737.00682.IvDoorn@gmail.com>
	 <1200501699.8708.9.camel@johannes.berg>
	 <200801161751.58244.IvDoorn@gmail.com>
	 <1ba2fa240801221226ra00fd76x8724b51023717b5e@mail.gmail.com>
	 <1201163934.3454.42.camel@johannes.berg>
	 <1ba2fa240801240717y35ed36bdjd5399f00dd73d687@mail.gmail.com>
	 (sfid-20080124_151759_169747_479A8ACB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-97SQTnOxR5hJ8eSTd//S"
Date: Thu, 24 Jan 2008 16:37:07 +0100
Message-Id: <1201189027.3454.129.camel@johannes.berg> (sfid-20080124_155854_947323_B30BDCD0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-97SQTnOxR5hJ8eSTd//S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-01-24 at 17:17 +0200, Tomas Winkler wrote:
> On Jan 24, 2008 10:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote=
:
> >
> > > Finally I got to test this but somehow I'm not getting any changed bi=
t
> > > set except
> > > association one. I'm still not sure if this is problem of iwl driver =
or mac80211
> > > If anybody tested please let me know
> >
> > Hmm. And you're positive the network you were on supports short slot?
> > But looking closely at the code does reveal a bug, short slot should be
> > supported even in absence of an ERP IE.
> >
> This should be present in capability IE which is always present

Exactly. It is ERP specific in the standard IIRC, but it should be
changed anyway.

johannes

--=-97SQTnOxR5hJ8eSTd//S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5iwoqVg1VMiehFYAQJsWg/+Jp0K/c5w13SHbyiXwd6f2+iHc9ETRNT1
31RM3hQCuxXFRxoJz74YILFN0vDnC4oZh15E213Sc6bmGVXWxcsDbs2hDBnx8fLV
IUlDfmcSKt3/Sa8mAFBsLCGqb5TdCIRH4OxGXJ8/fBre3Qgi+u8/RcvnAc3a0BYx
NZEK3AIy0mNswYugEU8K7O7WeeGapu/ihT9rK6WF6vk+PQ9W/aYplHfqBTMUZltR
3aL7vAm1HPPq/S0yjoBA+PeRv5717fK7IdxX3sZgQPKXbvC16Qs1NmZvBfaNLZqI
XgNL37lPJBcTg2fVzatJM3KxW7GmK1izOxlH+RHqeF6x9tc7+Z7c1DR/8o5Hk5nd
nLRB7ur1bgy+rvFZw0dOrhvF7rBhLMCvbcfL6DbQ9WKQSDwIzEf9kbktiLkVVCk2
YxE+YWRR/hVAiu1JZbe++nBdGtKsAmbGI48xorUoT4zYsfgc5AEZShev9Wns0rTo
ptr3xMX7JGflFDyNuBV0VTM2OKFwaH1O6OGWJ5LYCrJc5IDgjuM9JR4q7A1EY79I
FHEAxsYaRveniG1eYJKm71HRhTTS4C5ldAWYTgRRWQxBpC+ftmYwUUbxPFoPnp6E
BalvsaOpddYHaRzh3CIPXy6jaDZS4Rv/Y4+bZFL4MxYi48V8oKNaUFU7dxMWYHbQ
Z5pNr2NlPmc=
=Nvlh
-----END PGP SIGNATURE-----

--=-97SQTnOxR5hJ8eSTd//S--

