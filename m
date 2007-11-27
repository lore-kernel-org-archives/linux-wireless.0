Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59340 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040AbXK0NJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 08:09:10 -0500
Subject: Re: [PATCH 04/15] mac80211: adding 802.11n IEs handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@suse.de>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <jeabp028ga.fsf@sykes.suse.de>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <1196086490284-git-send-email-ron.rindjunsky@intel.com>
	 <1196094586.4149.297.camel@johannes.berg> <jefxyteygc.fsf@sykes.suse.de>
	 <1196096412.4149.311.camel@johannes.berg>  <jeabp028ga.fsf@sykes.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W7SYLJNv4vDjhLgd+QjJ"
Date: Tue, 27 Nov 2007 14:08:05 +0100
Message-Id: <1196168885.6058.4.camel@johannes.berg> (sfid-20071127_130928_878828_F5BC2305)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W7SYLJNv4vDjhLgd+QjJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >> >> @@ -89,6 +89,8 @@ struct ieee80211_sta_bss {
> >> >>  	size_t rsn_ie_len;
> >> >>  	u8 *wmm_ie;
> >> >>  	size_t wmm_ie_len;
> >> >> +	u8 *ht_ie;
> >> >> +	size_t ht_ie_len;
> >> >
> >> > At some point we probably should reorder the fields here to avoid al=
l
> >> > the padding... Not in this patch though, of course.
> >>=20
> >> There should not be any padding, size_t has the same size as a pointer=
.
> >
> > Even on 64-bit? In any case, the _len vars can all be u8 too.
>=20
> I think you are missing a couple of '*'s here.

No. I just thought size_t would be 32 bits, and all the size_t can be
replaced by u8 since IEs cannot be longer than that.

johannes

--=-W7SYLJNv4vDjhLgd+QjJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0wWs6Vg1VMiehFYAQKy8RAAq0f6uCnmwKzuWKzBdxVRRVYK+c18rlYE
3d5WymqEFGxPKyOdGtTgZJboo18zQ9pLRODWfLSSl4COkjcFjffL7fIQXcFJ1k8b
/Jy+GMgBetuDJxLJmySBVUkPeyMJpci+GOpDyMReAkLXQHW425xIOk3TYF4J6A0H
vKeyaSG/Anw9VG+BoRe6QcXFpdN5FH4EyryAunV9l2i3yNKF+54D3iwluIFd4viK
9ZxNXGhhsKyuv80UUPJDPs7gmYQhUb5quOEMOJ56ZSqYsrXSF0xMnZH8bmK+hr8W
Dws8A1oVyTo4N5lj7Q2eLVCc+g3XLGQzJbus+iWh26HiJbp90cuYQMfULVu+YWpK
AzEl7tdp4shSorwHnoDVk4TXHQFA7Yu9xOUc/kgCu+yR9COxxHoaID91Dje2ZdeE
INleQsZxGy7qqxKSLcknOqvPfdW6TnDkKwyxOovILcy7wd6dZcgBAKPeYagNmVbz
0u+pgr6vG/kWukzH4COUnXpEgvDiaRap7ej0BdZmKdNFLojN7Np+/ua1wvJYed4v
6E9EUfTjcNHcEspjL+VB5EsHRMDNflT6qOvH8JQ3+jABqjQq+w3t2YaGgvBcUqv0
519vNuugwHRDuv8ayTUIsuAoawIkpqWcul5ENTOSQBvbUbBayoEv+HWCxKm4kiCb
pNLc4LYJIww=
=ruGv
-----END PGP SIGNATURE-----

--=-W7SYLJNv4vDjhLgd+QjJ--

