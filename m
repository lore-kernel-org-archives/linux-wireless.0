Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38195 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZJQA1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 20:27:00 -0400
Subject: Re: [PATCH] mac80211: fixed injection in monitor mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Farina <sidhayn@gmail.com>
Cc: Gabriele Gristina <matrix.use.linux@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4AD8AB1C.9070109@gmail.com>
References: <1255658961.23827.2.camel@el8pc>
	 <1255704382.4095.340.camel@johannes.local>  <4AD8AB1C.9070109@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bEBMPeihKyvAKUMUBEsj"
Date: Sat, 17 Oct 2009 09:26:56 +0900
Message-Id: <1255739216.4095.342.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bEBMPeihKyvAKUMUBEsj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-10-16 at 13:19 -0400, Richard Farina wrote:
> Johannes Berg wrote:
> > On Fri, 2009-10-16 at 04:09 +0200, Gabriele Gristina wrote:
> >  =20
> >> I have a problem with mac80211 injection:
> >> if i setup interface in monitor mode with iwconfig and i try to send a
> >> custum 802.11 frame i see twice the packet in monitor interface.
> >> The first packet is right, the second is different only in the radiota=
p
> >> header: rtap len is fixed to 13 bytes...
> >> If i setup interface with airmon-ng the packet is sended once but the
> >> radiotap header is fixed to 13 bytes.
> >>    =20
> >
> > This is correct. The patch is wrong.
> >
> >  =20
> I'm very stupid, could you please elaborate how seeing every single=20
> packets twice with different headers is "correct"?

Look at the patch. I'ts the injection itself + tx status.

johannes

--=-bEBMPeihKyvAKUMUBEsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2Q72AAoJEODzc/N7+QmaG5wQANC/58gOP+R35tFBq1hYegzd
iR1KioVXWTC6VHc10gKfJ3GXYT24AKI/000CnzdjFx90dDgAA5OrQcN2CVpgCk3h
c3qdg+02tmcHYTL56742sxJtJhV04EyF+UYh2tayWqRq0/Ej39tZKuUqYpwdz+lh
3TRIQ8wCsCZS9RPtJXuftDrumqGEZ+Fk0E8XuE6Zr58FdMJ3FmK1dzIWPCQKTISb
s+ZHViZ1nuQCCBWW9Ab5LDoccigXc2ZaFUdAL/ijkVQOixdbu9RnvVPzDwM/xDbQ
pru46l5NE+v8IvnbLqhwpiqlDKiRYbzYJzdwLsxKQgGYDcqRDd5zdgKZFho1+b/K
Lhk+c2FLMl6OZDPq2m6m0b3ykgLJDVsv8a86IdZT0pIakpNZOITY469UYydTaO06
s3GTtQLsAKxjeLq33LomqtdbfH/eKZv0YG8iweF61IgxbekACtR91tJ3ze0U3apJ
DvEAXiVsPrdSyBiX9QdWAt7QEYY0zkC0eaQ9ZmWY1OlNLHHdMS3AmlKcDjTps3zz
NnyOIauQaFTg0vu80FQyfmPNMmO26HLYyuQVlxyCSyfD3F6hh/Y7t68JkRnRrEgs
KWwfZQltKomXosDk7wVD9A4wYVnBt3qxzZDFz/W3yxIMORMarZjP8kuQvF73M+8V
U8gW4qK21ybSmILPgOtr
=gVCl
-----END PGP SIGNATURE-----

--=-bEBMPeihKyvAKUMUBEsj--

