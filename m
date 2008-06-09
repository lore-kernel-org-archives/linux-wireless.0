Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYFIRrv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:47:51 -0400
Subject: Re: [PATCH 1/7] mac80211: add helpers for frame control testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213033412.5974.28.camel@brick> (sfid-20080609_194341_412413_70F0E00E)
References: <1212774671.6340.75.camel@brick>
	 (sfid-20080606_195944_782545_6A2B1449)  <1212997265.698.55.camel@johannes.berg>
	 <1213029086.5974.21.camel@brick>
	 (sfid-20080609_183129_796413_B211C17A)  <1213032085.22220.1.camel@johannes.berg>
	 <1213033412.5974.28.camel@brick> (sfid-20080609_194341_412413_70F0E00E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ST5jnsLApAr4voz2FtYT"
Date: Mon, 09 Jun 2008 19:46:19 +0200
Message-Id: <1213033579.22220.8.camel@johannes.berg> (sfid-20080609_194754_204825_2B58C75F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ST5jnsLApAr4voz2FtYT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-09 at 10:43 -0700, Harvey Harrison wrote:
> On Mon, 2008-06-09 at 19:21 +0200, Johannes Berg wrote:
> > On Mon, 2008-06-09 at 09:31 -0700, Harvey Harrison wrote:
> > >=20
> > > As this helper only checks for the one bit being set, I chose _has_.
> >=20
> > Hmm. As far as I can tell, it checks that the frame is a QoS controlled
> > data frame. Hence, it explicitly checks that it _is_ a data frame and
> > _has_ the QoS bit, but in 802.11 lingo I think that means it _is_ a
> > "data+qos" frame.
> >=20
>=20
> Well, it's not a big deal...what name do you want and I'll change it.

I'd prefer _is_qos_data because _data_has_qos makes me think I have to
ensure that the frame is a data frame before passing it in, i.e. it will
return undefined results for a management/control frame.

johannes

--=-ST5jnsLApAr4voz2FtYT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITWxnAAoJEKVg1VMiehFYZEQP/2V57G0jvysaT8KlSZ6hwGxl
l24exPj9AO1FNzpQrYEtm1FEBSBxhp4Y2mnBlq4YXvGki0fZLD/DMyLsK12Zpfyf
//4EIEg7yq7jwrPWR6eZBPEmSn0JxyJkVvFDW+IA3ZnomTXSXBrDxwmKh4xVx71r
b0OzgZVK9JlZ5KiyC8Zg2s6LsF4joTGhaUjCDK+ourbYBC343pTLZgB4iAb1+IxK
7NKi0yMQ2oK404ZGZNlONKsubAVQ1iMMPS55dpZfGcDG0ymtN0x8G5Ar04zt09o3
fsRWFXVHCABx8ogaaH/mz5AHpJBEABqUU/+FyLEWbuseZkDnHk22BqKt41LpPPhb
PN488Tm3Cl+fbe6bWsu58GsxUkqd/aByh/4zw98U8wDELkahKjtT2O8kp8/ABu+b
H+sd1Anjah4muMqCUhdG93YUyNFxv2NuPbFGXltjloh4G8PHdhpSkWy8xlGQUpae
XHa4CESVzmxWSRogpc8ePJvUjX+B42F8Nf8e7XzTIu78sK+ajQNeFGQXFb1W7l3/
3OR4h6GawAgoSbJfG58iFQLM3twAxHO2Z8N3YkcHuR1qv7ujFhxoZj8+D84+NWzp
MayM53mXlo4jqkg/92mk50pZXxggcRXDURAI6RPDqDlcj3hgjYhssaUB6b8YhIth
pY6DunWXJKDHJi66MRLy
=iN7i
-----END PGP SIGNATURE-----

--=-ST5jnsLApAr4voz2FtYT--

