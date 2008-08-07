Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbYHGOpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 10:45:49 -0400
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080807143232.GD5138@jm.kir.nu>
References: <20080807134043.GA5138@jm.kir.nu>
	 <1218119110.23048.185.camel@johannes.berg>
	 <20080807143232.GD5138@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+EJtVxAB41NbupGqBWlM"
Date: Thu, 07 Aug 2008 16:45:13 +0200
Message-Id: <1218120313.23048.187.camel@johannes.berg> (sfid-20080807_164552_684849_4EA58B82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+EJtVxAB41NbupGqBWlM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 17:32 +0300, Jouni Malinen wrote:
> On Thu, Aug 07, 2008 at 04:25:10PM +0200, Johannes Berg wrote:
>=20
> > > +	NL80211_ATTR_BSS_SHORT_SLOT_TIME,
>=20
> > Oh another idea I just had, I suspect we should use these to indicate
> > support for the features too, on the wiphy info query result or
> > something. Only tangentially related to this patch though.
>=20
> Sounds reasonable. So far, I've mainly worked with hardware that
> supports these, so I have just assumed that everything is fine and
> haven't bothered dynamically trying to decide what to do in hostapd. Or
> well, it was possible to configure this in hostapd.conf (though, it
> looks like that was never actually merged into the open source version
> completely, so the variable is there, but not a way to enable it; have
> to fix that at some point, I guess..).

Ok, I think the only hardware we currently support that doesn't have
these doesn't support AP mode either, so it's probably not really worth
it now...

johannes

--=-+EJtVxAB41NbupGqBWlM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImwp2AAoJEKVg1VMiehFYyBsP/3H2FR7XFRol90pm2HMqITbd
74Xy1h7NT38f7Hjh3CQw5RvUR1Qw9El8SOsLp9citcNSEERy5aZlXBEQii5fBrp8
h9AR/vu8ZgSl0QDSvKKNm7xNZ0SjQFdd3/C+EkqJ9YtMbnauBlxFjMgi6bekIVMv
tMH6LF48JO9h17yuRvyzOqX3Wsdz9zu12yBXyAuSZK1Kpiaw3SPDvIPN75FBYK6O
4m7kLS3OJ1jRBikmDRUPI+fGyd7UnJsUnd6R6NJmKFrAa3cMNjcL0juosbyXEXIj
8i/RbFfkhvRwQtj/agON453OWxc0Hq+VRbIEFIJ8aY+ZGWBdCe0UHh2p9kudOFVD
TdTr5QSJuxaSgwHQW1RpRQ0z7S1Oednca39D2JcbZbP76Dp6NuwxGzp8TL2z9xBn
TnvbZxezR0Eg9HYPqTDX7+D8cSRWqQNoYjjs1wYPNZ+WUar8fH8lmVOIMEj7Pu6j
FeQf9t33jAFEDCEWqltRuiTL7Xs1IU7s1UtQe9yFfgQ6ZczZwfqJZ0xSY6Ya2mT6
eiA8BNbkB7wIunZAD23Cv/YxoRXv+otLNaI4CWrMYfj2GX24ti8WZ7H27arp5F9P
S0WkPSeREVlEJZP234DkIRMNPRAGtt5qcgzWGxQHOACu1PNiJxFDSPQ5YmnzjzKo
y0gF+cunpdXlDREbFfmA
=B532
-----END PGP SIGNATURE-----

--=-+EJtVxAB41NbupGqBWlM--

