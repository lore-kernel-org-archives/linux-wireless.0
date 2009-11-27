Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZK0JSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2009 04:18:21 -0500
Subject: Re: [RFC 1/2] wireless: add ieee80211_asmdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259284014.13126.111.camel@debian>
References: <1259215413-16753-1-git-send-email-yi.zhu@intel.com>
	 <1259228968.32372.40.camel@johannes.local>
	 <1259284014.13126.111.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NoN+2amR4Y3zkSa5KUOC"
Date: Fri, 27 Nov 2009 10:18:20 +0100
Message-ID: <1259313500.5428.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NoN+2amR4Y3zkSa5KUOC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 09:06 +0800, Zhu Yi wrote:

> > > +     dev->stats.rx_packets++;
> > > +     dev->stats.rx_bytes +=3D skb->len;
> >=20
> > Shouldn't rx_packets be per sub-frame?=20
>=20
> Not very sure. Maybe it's one frame from the device's perspective? The
> original code does this so I didn't change the behavior. Should I?

Ah, yes, I remember now -- had been wondering about this before. What
does everybody else think?

johannes

--=-NoN+2amR4Y3zkSa5KUOC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD5lXAAoJEODzc/N7+QmaisQP/RdFNjDPnyKf0iifvb8Q7puZ
ZysbpfJxxbdJsQaY2b0KQSHy3M7oTcbIhzoMKevMvWRh942EqRPaDlxX+rzn7I2M
/zacVRu3DWmLbDTaGHNIcu4W93AgxYNclvfUEfFP3wGZqR4/Msc3eoy4X0qB1Fqr
z0O42yEBDCnOC6x6VW6eb5v+GHUt2lZPWb9N86E3ON4Cmf4pig67y83NLKGeb+yK
1CvqMLS/yfQWsvzIkG9YXLB1V9kNR2RBCYFcNGWiAAsIBOoSfBJ/Zzwn/eSdn4V3
guidhZIRHbil2qe6/JhB1jH8V+XAe0n1KdOxx9x6gG8k5HLPVRrEyIRKis6g0qD+
Hek7QhiAcPWPI9gZTvtuavo41iybwAE8+aC5xQV2iyJwD6fDvF8aF4SFEOzYYbzl
y4oBwLBr/2iuDv90KMZxaj5CqcGYZhg3K+Ne3q21NfYUOsyXxT1R+w8wmBePpeC9
Rb2VDmUIy/qGZPuwxboyutqNLnng4EEUJJGUzKC5FgH9m8Q5zlphkCbkLGcQNnQ1
kISzZo4nSlbx+fNFWssfhKxBLp3ksv/HvYPZH7ghFfL/Wn2E5qut+lkVUQh3FdbI
KUlTGw0GzdjLP1Gwm977hkD5IoZLv4dGONMaq3vVFTB44ZqzHa4pLA+jbifFYf0L
gDmxnHjt/9OggX3aDbuF
=qw2G
-----END PGP SIGNATURE-----

--=-NoN+2amR4Y3zkSa5KUOC--

