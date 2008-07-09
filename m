Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYGINmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:42:24 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091538.09387.mb@bu3sch.de>
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091511.45779.IvDoorn@gmail.com>  <200807091538.09387.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VHvQ/v1/rxIL7q9W+LN0"
Date: Wed, 09 Jul 2008 15:41:38 +0200
Message-Id: <1215610898.3246.6.camel@johannes.berg> (sfid-20080709_154227_861431_20D09CF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VHvQ/v1/rxIL7q9W+LN0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 15:38 +0200, Michael Buesch wrote:
> On Wednesday 09 July 2008 15:11:45 Ivo van Doorn wrote:
> > Currently only beacons generated in AP mode have the software
> > sequence number inserted. This means IBSS and Mesh mode are broken
> > for all hardware that require software sequence numbers.
>=20
> Does software seq numbering even work at all?
> What about packets that get sent between the driver requested the
> beacon and the driver does actually queue it?

Hmm. I guess we'd have to lock the master device while requesting a
beacon... but also lock around the driver code queuing the beacon or
something?

johannes

--=-VHvQ/v1/rxIL7q9W+LN0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdMAOAAoJEKVg1VMiehFYvOgP/13wCm6X+oSl8HVO+QDOLwm/
lW+Z6PEji1k9YdBUCXkhFP21YaSSCcwwY5jnYABRVO3CNAVPa2XAYkED57hTRgnq
kKGfr9vDE3/vXHYYOCTAjWNFStTAW2vQxLADLHG9LOfROcsUla/+OSZMzecTPcLo
t6qgE6cH036jG29m01M8u15G8G6eEMfwvN3Ma8lqr0d5P+kOs/FxxbqFHohlbT3B
XDgSZaZkZwgMnm2cKyA8c1YkKNzEaMwtB6oDNanSlWmb6d6EuK7OckpFoj+rJLmr
5cJYjC+KtoY/Vv8D9VLa9iN4GvB0YJSZD73x1oC8w2iGMRERhqnAHlh4PLlTNxe7
A9waooxJRrQafBy88fwNobczP6J+a5b5S40cIPtH1mWQ3tqvhefGzKwAbOetK1XI
ThJE95TS6crbswn5BetBAF1ET7/qSD8mcqPjuXgB1iHOtvBprK7l2YCXyKxkiWpu
BjiMPlKzltu1UeFuGDtc2Ot9GYVmb+HCffqoGn7GiERdZhjXdqLOa7iXwCrO/JZu
BbjDOuByQQq4rMvV/pztWlVLuOZQG9DZrTpxJ9mJlAqZmgud3edAbhhARLS+6KD3
uTqsO/oo5VkXRcFF1BMP5v1dCABchhv5ZGGh2Dmcwtcpab8NycU/cY0SmQpzQ8tz
t2NxxbMXo1LCFRlCKUHj
=5dck
-----END PGP SIGNATURE-----

--=-VHvQ/v1/rxIL7q9W+LN0--

