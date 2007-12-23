Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbXLWV3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 16:29:41 -0500
Subject: Re: tx_status reporting of RTS/CTS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200712232217.18941.IvDoorn@gmail.com> (sfid-20071223_211655_378805_46EBCFFA)
References: <1197412922.7030.11.camel@localhost>
	 <1197479702.6558.125.camel@johannes.berg>
	 <200712232217.18941.IvDoorn@gmail.com>
	 (sfid-20071223_211655_378805_46EBCFFA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h1l3014VUxk87ZhSyUlp"
Date: Sun, 23 Dec 2007 22:29:12 +0100
Message-Id: <1198445352.4103.0.camel@johannes.berg> (sfid-20071223_212955_483459_3AB79143)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h1l3014VUxk87ZhSyUlp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Than this is a problem in multiple mac80211 drivers, since rt2x00 previou=
sly
> did filter out rts and cts frames when reporting txdone events to mac8021=
1
> and upon request on the linux-wireless list that filter was disabled, bec=
ause
> the other drivers didn't filter the RTS/CTS frames so for consistent beha=
vior
> the filter was removed from rt2x00.

Huh? Seriously? I can't remember any such thing. It doesn't really make
sense because most hw will handle rts/cts fully transparently and not
give you status notification for it. As for showing received rts/cts on
monitor, sure, but txdone for sent rts/cts isn't done by any driver I'm
aware of.

johannes

--=-h1l3014VUxk87ZhSyUlp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR27TJ6Vg1VMiehFYAQLPZw//b+wqRCWOQjh6oIjY0KlPAjNF+0Hq9z8o
SLVv+F/C8NDfKEeLQhhvXV58iVDw34OFHll/yqOpcjCSr206Gex3F0juo//CGi3F
7cm1KrrAG11UL57QcPYhafx1Fm83uqTLV2+6icls36y0l/zOcpx56MxQpT9S6oTu
aaYRm6EAu7HSfmJIE8GcyYvDB7pzRGwRQZQyaEzfKGVHQ/BIHhZysom6Rmf4mDrg
ymyu7EpbzcjbVW6a37z0cRBJVNaX/29wLjg41HH5tqRVYHnFace6UPFsxTbjZEDw
z2WnC4u2hyY1/SHQpTGgyBLEm+1oZ2syV+Euke4+wXY4e6asNRrlrvCbLG3NZXYt
P6i21hCHNk19FggX3NYulQlWLDXuZsX7HA5krSh8GA88MTrtmBevlfAkowXvkac4
o+dG0H9+5aCIQ2DsOwg4OMlJcEbc8aD198omBF7LDupQJeRIbBhLXFoOFm/Vbmrl
P+/ZSq7FUpVI4hudjos+ZpzzGmFcqlsiiCWmi1IFrSVRek+KN+TSBo1Durt8nkWI
VMqlpayfLOSbB1JoskLUkXByTRJ8F+IR7SePyMiRQOwq4g4+PUNQSgsArHN8qX6q
QpVD9WOsBN9m7YCKOzCTQaSzDDhKeEn0kCENh3YrLoqPvBHmx0nkxy/srMpceMFj
21p1Ax/d8H0=
=wFcq
-----END PGP SIGNATURE-----

--=-h1l3014VUxk87ZhSyUlp--

