Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:39187 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaJMGOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 02:14:19 -0400
Message-ID: <543B6D48.5060807@meshcoding.com> (sfid-20141013_081430_825564_DA29F693)
Date: Mon, 13 Oct 2014 08:12:24 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Sourav <sourav.chakraborty@netcommwireless.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: how to achieve SSID isolation
References: <543B1889.3040600@netcommwireless.com>
In-Reply-To: <543B1889.3040600@netcommwireless.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JgrQfLelclxQEP6eoVVAJqdMqBcntWhKQ"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JgrQfLelclxQEP6eoVVAJqdMqBcntWhKQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 13/10/14 02:10, Sourav wrote:
> I understand that client isolation(in a single SSID is achieved using
> "ap_isolate" parameter).
> Is there any parameter in hostapd.conf to achieve SSID
> isolation......i.e the a client connected to that SSID, can't talk to
> any other clients connected to any other SSID?
>=20

I think this is something you should easily solve at the layer "above"
hostapd. Each SSID in hostapd is represented by an interface, therefore
you need to prevent hosts connected to one to talk to hosts connected to
the other..but this is not hostapd's role and it depends on your network
configuration.

Cheers,

--=20
Antonio Quartulli


--JgrQfLelclxQEP6eoVVAJqdMqBcntWhKQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUO21QAAoJEJgn97Bh2u9eRlcP/2DJpMbAvOd+UDnzbkLXtj4Y
rWDQe+DwAzkxlIhiI3V5icvtXl47o3JiTWSq+65sJw4UHbSBv/kqDI9fMItgRYzK
kORhGiyR2bg2ojjl8qFOH0wDhNxMKOfh+WszpyERCiCHCj8O8t5Y89swYvUWCYfI
l4kceyvTety3FwR5eufgs6HBjnevbIbcQQroAD6JkJI4hjSsxcxgeVRtFiuQLUv2
w0+0HfUAPCSxVf9axrp1rQnQLTmLV3eBckijGYLofHvpcqLRC5lG7s7OMXwJW3oG
PrAxa81wn6tVuwqlJPnGr6yE9OmjrMttzXAoFzsbBawgXpERBfoDaPQfo3jpUeoD
r7GK1KG8Pqu15yvdGrcYt9VDJdzZzooxIEddE9NRRrZoZvfX/OeGMDgz8dvS4q3Y
9ixi6eoqoRYFpHRStYA43P5pjI8I6rISZHP8KtHdU32eYMyeTjoS/Fq+lXpd1Z7c
cOdDB3VstLdqgAZ8uzgJy28rOSx8keIGjb0dFKECkzl8dgfuwOSg5I0mF6NFDSc0
wtDGWgSS8Ysb0U3ZmFyT9GsG79VNGYrH7mcC+jT+ea3aA18l9MmEG5CkMHCUb2ZD
jl1qqnE+QHlZheqDQrxfAgmbnTOIX36Iah4fRgye59flcEkmcK3u/piwH/yB27PZ
sdz4ev17xf9+ymOLbFRF
=u3In
-----END PGP SIGNATURE-----

--JgrQfLelclxQEP6eoVVAJqdMqBcntWhKQ--
