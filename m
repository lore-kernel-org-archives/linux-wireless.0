Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaKHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 06:07:42 -0400
Subject: Re: [RFC] wireless: Add 802.11d support
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <490A94B7.9070609@erley.org> (sfid-20081031_062345_260350_2A1362ED)
References: <1225428211-17353-1-git-send-email-lrodriguez@atheros.com>
	 <490A94B7.9070609@erley.org> (sfid-20081031_062345_260350_2A1362ED)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xJ2S4LphVrx91VmgZ4DF"
Date: Fri, 31 Oct 2008 11:07:39 +0100
Message-Id: <1225447659.3535.10.camel@johannes.berg> (sfid-20081031_110745_618668_3497263D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xJ2S4LphVrx91VmgZ4DF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 01:16 -0400, pat-lkml wrote:
> Luis R. Rodriguez wrote:
>=20
> >=20
> > This is not complete, I'm missing the reg.c part, but figured
> > I'd send it out for review to get comments now. Anyone know what the
> > country IE extension thing is? A quick glance at 11d gave me nothing.
>=20
> http://www.winncom.com/pdf/802.11d-2001.pdf
>=20
> Section 7.3.2.12

Was something reordered? In 802.11-2007, 7.3.2.12 is "Request
information element".

johannes

--=-xJ2S4LphVrx91VmgZ4DF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCtjnAAoJEKVg1VMiehFYdrAP/Rr1UVdJr5BfXjYS5TQQeQSN
hHeZ0lFd+kyIcT5TNluN948MQOonpoHdgFtTpjHmCBbWlVXd3LNpF/xIUcjFlyyN
PQ4uAARjSUnzl6rcpbbkX3fatS5jdYpQyA4x9b5APL9IkvzEU1FCtMRuVA/VrxNa
5KLfZ+tjNjHJ8sFd6CCJdPQPFN2DhR/Ah3snAgEU+XhKwWqTSkfe+ii98UJh1QcH
MJt7n4FJ4wgbvKgKInh0j9rFOxplRhpB1lN03NErCCGqPW/99gf9ASC2hGhAGCtw
hBXWpKWreOfXn6LgXQ411owNTHRG79EGjXeEW/3RfTdvsWAnrcN2kJKxWDqp0b1x
D9Ypp8onlJRReh2fDXpKFDRY5lBip0x5KD1FUgqdqTQMos3Y4WPBtqvi+P/T55NI
ivm/l2PM5O81m2m3PpQJINsLaZzjrantpuuYDFv4qXL0FcPH6o8i1wqmre/Wkwuo
6UhIMtUtL5wBxQ7Au0ijF3kaEa6Bc6QegrhPV4rahkRjOCZ34bkwHdQLei8ylkXs
UREHohumRaTl1WcN8uGN/p6OgBxF7xROn2tznsUoAAeMCsfql/McEEPsHw5wTZwu
KQvpf+VSaGYEBtcv20l63cgCzeoxwfl2efnFelGgp8NI2fWLH2TYozOKl0mqaG7J
XD32ySHeY2ad8n+xB82M
=p1Ql
-----END PGP SIGNATURE-----

--=-xJ2S4LphVrx91VmgZ4DF--

