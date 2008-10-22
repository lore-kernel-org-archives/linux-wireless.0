Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYJVTbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:31:50 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20081022122704.GG6190@tesla>
References: <1224585110.5521.8.camel@johannes.berg>
	 <20081022122704.GG6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xDjuSm6CsINfCpZ/yRPJ"
Date: Wed, 22 Oct 2008 21:31:43 +0200
Message-Id: <1224703903.30459.65.camel@johannes.berg> (sfid-20081022_213153_840337_50304003)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xDjuSm6CsINfCpZ/yRPJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 05:27 -0700, Luis R. Rodriguez wrote:
> On Tue, Oct 21, 2008 at 03:31:50AM -0700, Johannes Berg wrote:
> > +extern void regulatory_struct_hint(struct ieee80211_regdomain *rd,
> > +                                  u32 bands);
> >  #endif /* __NET_WIRELESS_H */
> > --- everything.orig/net/wireless/reg.c  2008-10-21 11:50:14.000000000 +=
0200
> > +++ everything/net/wireless/reg.c       2008-10-21 12:26:08.000000000 +=
0200
> >  EXPORT_SYMBOL(regulatory_hint);
> >=20
> > +void regulatory_struct_hint(struct ieee80211_regdomain *rd, u32 bands)
> > +{
>=20
> <-- snip -->
>=20
> > +}
> > +
>=20
> Oh and forgot the EXPORT_SYMBOL(regulatory_struct_hint) though.

Oh, good point. Maybe I'll just let those who test this stuff add it
though :)

johannes

--=-xDjuSm6CsINfCpZ/yRPJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/3+cAAoJEKVg1VMiehFYGKEP/0/qq/r97qEc75osiLHQOKxd
SkZtaHChrQ+CScpMrE+a/CYXrVufjDrmHYwe1NY1DWmqK7SAvi+qnuQhtVxheAxx
aa7SD2Y6SINWki7FI4Pu6nUElr3wQAjs44wIk5kZp+25jwTF3UjCZwYSGynHTfWO
zjTTeI5aoRXju1wMBUXJmby3X6qeQHcIW+NW9qsrxxetnM6Hu0wdvapI4dqQZ10v
PU1nr8NHRfhAbOCZb8U5knVI6/Az+g6fJng3TGq1sHZNqOMij+90EnRdrLpzd9yI
6hgTd6kxrnlk88OfCHJ5bZjNXk9eViqAm9sLeIk0jnfTn3R8OnzbN1YRlJdPnvFb
7L2f3oWp0vkJw31uwafJdHkkp++SozSaoxx+LCLRKLbkrntcP2o5rTDXdUzkCJFM
jN/uAOb6CZtjKdNJIKfLc3U+WMPMZdbVJrJHDWD130fmyChwsZMwmOIisy58lEum
bVPwmDMsiACkZTMrB7I3WOMAE+fE0SfRrG/+vkk1NhVyvmkf44In+F7o9qWybebM
oMqG8f9//P7sWiOeEtpWtSDmRs3jT2FNNG8kBsjY+oK5MQYCqmpLMJoQulkxbj+Y
grJNJhlqxGjDXa6IOlicETfiSpjgJMicTyKgEeRf14+6MCNlexjKRuGzlkRrMdpp
rAc9VEV43BuYp//8tZvS
=JoNL
-----END PGP SIGNATURE-----

--=-xDjuSm6CsINfCpZ/yRPJ--

