Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbZFWLlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:41:06 -0400
Subject: Re: [PATCH 2/2 RFC] mac80211: connect API port
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090623113712.GA5349@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
	 <20090622175154.GC30147@sortiz.org>
	 <1245755947.4184.42.camel@johannes.local>
	 <20090623113712.GA5349@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gmaU3kJgNJXUmZKayEcd"
Date: Tue, 23 Jun 2009 13:41:06 +0200
Message-Id: <1245757266.20595.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gmaU3kJgNJXUmZKayEcd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-23 at 13:37 +0200, Samuel Ortiz wrote:
> Hi Johannes,

> >  net/mac80211/mlme.c |   54 -------------------------------------------=
---------
> >  1 file changed, 54 deletions(-)
> I thought about this one, but wasnt sure since we're now sending an
> IWEVASSOCRESPIE event while the current code is sending a custom one. I g=
uess
> it's fine, just wanted to know if Jouni is fine with it.

Complicated story, but it boils down to this being ok if (and only if!)
we put in the wext compat event patch. If not, we need to send the
custom event in cfg80211. Maybe that's safer for now.

johannes

--=-gmaU3kJgNJXUmZKayEcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQL9OAAoJEODzc/N7+QmaDukP/2iHLkT16xZ0O2J7uxG/VADg
6oPg7h+XHEOVRUVkWFln8lp4r1Fb2X4++7UsGDXeVF5HxAe4CPUSuJ21CG6P8STn
g+7DS7pRrVe6smF3TZzPkPAzkbUlf64Unkq7Xz2JAsT3TRA7cxrUt2UbASx2nyGR
oUBgXyzWWBTN7Pvcq8x6TvUkM1NGXhWEo5vfWUgE5Bg+OGuWk7ntCCpowyPV48RP
s0wcafTX6N+rWaFLZW0PwDxkmd0k4osifpg1lYLgsg3FJimeWtzfeauq0rE1+4BS
7Ow1vDt9uCuBFulpMK5IkBr1xgUvMDoq+SMdTezFioxjsp0CXvRwyT0kC0+DZcqI
+oYazJqpB/tJ2MCBCt7eysP7c7LuHuxi4HV6Hzl90LWEJ8ojOex11qVXZi9bljUO
APbMh0zYXicjAF4nKD5lvJRU1XuC+fDkPxIR1AxS08XcZUOX6QwOieSMZYxYFNRs
pzggqxVEpJtY6dJwLjJySVZdQjPUYNWICrXOu9frmA277dKJiyHBzZXgGvsx453H
r73Jcqs5SSCEEgpMC06qDvF20xpUP0SWNUlkLGioS6kPCiLj+sHzHr/3sOyNBosW
TRZQgDpuXZOqnuxYl/rYs6L+eGzILCoZcZahMC/WjNbVSlKcbUoKbOGPbzIWpNL+
KZAPlXJne5iJghL9EwQe
=w3H9
-----END PGP SIGNATURE-----

--=-gmaU3kJgNJXUmZKayEcd--

