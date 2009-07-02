Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35481 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZGBL43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 07:56:29 -0400
Subject: Re: [PATCH 8/8 v3.1] mac80211: re-add HT disabling
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>
In-Reply-To: <20090702114316.GA12652@jm.kir.nu>
References: <20090630115303.111250594@sipsolutions.net>
	 <20090630132547.GB24667@vasanth-laptop>
	 <1246369077.16643.10.camel@johannes.local>
	 <20090630135207.GC24667@vasanth-laptop>
	 <1246370452.16643.11.camel@johannes.local>
	 <1246433956.16643.35.camel@johannes.local>
	 <20090701101336.GD24667@vasanth-laptop>
	 <1246444959.4131.15.camel@johannes.local>
	 <20090702095134.GA11235@jm.kir.nu>
	 <1246528397.16770.31.camel@johannes.local>
	 <20090702114316.GA12652@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-92m7CvxLho2zVRYVXqDD"
Date: Thu, 02 Jul 2009 13:56:26 +0200
Message-Id: <1246535787.16770.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-92m7CvxLho2zVRYVXqDD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-02 at 14:43 +0300, Jouni Malinen wrote:
> On Thu, Jul 02, 2009 at 11:53:17AM +0200, Johannes Berg wrote:
>=20
> > So we have to support multiple for connect() to allow the card/driver t=
o
> > choose, but a single one for associate()?
>=20
> Sounds reasonable.. Many drivers might not be able to handle multiple
> options for connect(), though, so even with that, it may be reasonable
> to just pass in a single option.

That's something the driver would have to refuse then, I guess.

I'll send a patch to limit it to 1 for assoc()

johannes

--=-92m7CvxLho2zVRYVXqDD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTKBlAAoJEODzc/N7+QmakpkP/2Kpn/Ti4aSATE8LL18x1y4z
7gPUeKk7OCO9+GMwEpQObTawvbLc/3ctWsktFDDRA2MWSg5gr6Mmo7q8ZlNNDUDB
SzupehUqxYm6NluIt6GmAHHFjVwJB7/dbvTJhMr+Qnhi3SZSNAreevmCtlX92DBB
MrwEzPuve/2/mymCj76i+7QqViqYDOOaktwmTRadgtbS5atnQpNx38owjO3PMEHM
ATt9+wBvyY3ja4+QIGZaleR0prZgqA4s232wEqUC4C5Vl4kdrqi1EJGJsYd2mgBD
JIWZx3izopLCcENBR5mk1WutqmebdkCIAW3hujBhBOfUb5gZpg0Mr8mXRVtvnuFq
rvH9Vj3A1dB9nzU9LQ2OlDgYZ/xd+FyMl9CDn+Ju6p+5VuUk0yXRizCIln7hQy5m
Wv7Xsf9HtUvzh6V/uAXwNNle4r8n6To7j9ab8U8k73Bniuo/wXhVf4HMep0uB2FQ
jjDWTVbbtvK0CIfft81uqDAPWbBX35DmgsL1DoFj7krO89/vLpxiJzyK96SMZlnN
lKn6APPeIG+Y7e8uQueZvczSfRNrHuD2DDLYsB6sc4IugyekqmZ8JJCHg5VD3cmM
jDQX+PcII7DIclZIus2uXZh8mjhUTNpSOVkXccYk5eLpGTcoOUD01w2dFejzOStO
+delOY1hiZ53XLQXMK3t
=i5+A
-----END PGP SIGNATURE-----

--=-92m7CvxLho2zVRYVXqDD--

