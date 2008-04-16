Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbYDPOIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 10:08:47 -0400
Subject: RE: [PATCH RFC] mac80211: Fixes n-band association problem
	withcertain APs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <BD524EA7912ED5469DFD0BAEF6BC752F038E39C1@orsmsx411.amr.corp.intel.com>
References: <1207867745-26538-1-git-send-email-reinette.chatre@intel.com>
	 <1207943021.13354.76.camel@johannes.berg>
	 <BD524EA7912ED5469DFD0BAEF6BC752F038E39C1@orsmsx411.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fLabrNeISRQH+YOzEiB8"
Date: Wed, 16 Apr 2008 15:59:00 +0200
Message-Id: <1208354340.11676.33.camel@johannes.berg> (sfid-20080416_150849_511129_0F319474)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fLabrNeISRQH+YOzEiB8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-04-15 at 10:01 -0700, Kolekar, Abhijeet wrote:
> There are two structures named wmm_info and wmm_param, they are used
> while
> Parsing the beacon frame. (Check the function ieee802_11_parse_elems).
> Certain APs like D-link does not set the fifth bit in WMM IE. I was able
> to see it thought packet capture. And this patch fixes this problem by
> copying the wmm_info to wmm_ie, which enables the "wmm" flag in
> iee80211_send_assoc.

Ok. Sounds like we want this, but maybe with a comment saying why we do
it?

johannes

--=-fLabrNeISRQH+YOzEiB8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAYGIqVg1VMiehFYAQLRphAAnBxLaSJgQ+YWsLbSqp95bOcRzwHJTW+c
bMC6ARUTckUgtsVkdVf3tguMc3S4RZPhqZmBfqwAlbaDuqfDdasld6s2GPnAznDO
n6ZBs800dSi+OqrRFzYaqd8MLTulWvBvSfwZczRt72Zhx/Ll7LA046eYCwXiBK8M
AYXRlC7njBuXDgwZB5MoJerFH1NMGcO/1yddm8kefr1nfGsvmc1LERrv/pDj1noI
M9BrssWEQ/q5k1q8tCzS4ujIjQY/X7rakokiBJ8Hn3KIpppPSc1Be4q1f8T2EcBi
KNohntVHsghJ+E/9KKeuRuSTljFzn3FtLaI+nUfj8djROhNt+du3m3L145dN9Mr1
f5vxL2VnHERx2yNRquq/Ux4n0rL7znz7loaU+jyERuDmIQ5LpdNYf9sOc+xqNpaB
2u1b2IR1qb8bmECKQ/GON1qSr5tRlBXFAHwSpkXGCeGjStRzp4QeWUPx4ptaAkDw
Fsa3fzNQ3pM9w4JTVFbETTLKNUv1sW3X4SR6Z66q5vXJajSWrc52zjQWgunXghhR
iiDJYWKpVSEAv/W+gbPyUe9iX+exkhA4PMoFRTVhjreYTI1W3dkkOCPosxRgwp85
XjG8JwcPHQg36UkssKiON7NUV76ABU3CU2MNHoIMy5jjziLhPkcKLxGZ25ta2FUp
OsletuI5iZM=
=FqJJ
-----END PGP SIGNATURE-----

--=-fLabrNeISRQH+YOzEiB8--

