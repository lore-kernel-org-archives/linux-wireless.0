Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbYIJVi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 17:38:56 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221052167.4648.9.camel@localhost.localdomain>
References: <1214149401.8585.2.camel@localhost.localdomain>
	 (sfid-20080622_174624_286344_54D543FD)  <1221033061.12266.10.camel@johannes.berg>
	 <1221052167.4648.9.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F4KHZI2MzUL7xwT3xAJk"
Date: Wed, 10 Sep 2008 23:38:08 +0200
Message-Id: <1221082688.3804.45.camel@johannes.berg> (sfid-20080910_233859_002136_F2B8F859)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F4KHZI2MzUL7xwT3xAJk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-10 at 09:09 -0400, Dan Williams wrote:
> On Wed, 2008-09-10 at 09:51 +0200, Johannes Berg wrote:
> > On Sun, 2008-06-22 at 11:43 -0400, Dan Williams wrote:
> > > mrv8k has commands that get called before and after the scan has been
> > > done to save and restore hardware state.  Add optional callbacks to
> > > mac80211 to enable low-level drivers to know when the stack is about =
to
> > > start scanning, and when it's done.
> >=20
> > Was just talking to Sujith about something on IRC and realised that
> > maybe this is required to turn off IBSS beaconing when leaving the
> > channel for a scan?
>=20
> Most cards to the beaconing in hardware/firmware with a given template,
> right?

Yes, many do.

> If so this sounds quite plausible.  Does beaconing not get
> paused now?

I'd guess not, but I haven't actually tested.

johannes

--=-F4KHZI2MzUL7xwT3xAJk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyD49AAoJEKVg1VMiehFYNjgP/iHJK2wyqO+kFwIEu9IM7Cdp
GZB9Fti1jm/FVIlg5Qs9Blk7KWBNJdXg83y+ppJeuxGiv+V814YbGegwCN2AiwdE
kvlWhJ1PPOW/2bJ2xtP3kZSCh4Ju7SKXkgzoLAbQ1cbtUOQwI+qyJ9sRJ7eLNp/E
u4VcMCADVLu1eO9tlSr37/dkThEaWL/NMhcVGoMjcCpioZhjaWcLuPE3YthGNq7t
mnRjWDSBIOhqLn0E96QWhkgFmmbGMG1t3Vg4Qbmubi4igDAHSMcLAViQZwbcdYW1
3pevu3YIgEjggPfMotm8AvjD4giRY/7FK9HXs6mO2OiUe3sfUI8DBofln9ZFjHw6
H3p+LdQgvtn/VTwi/F8VgFoM6T2ss86nLw0A8FO+JLu9qjcQ4Ldb7FEzYCVoEkNN
Ye7FGjVlKrtevXFhnanUt/nkZcOpaVnrcILJ+gQK1iZGz0f0xJHxDM3D92ohAY2f
3Y0oOxHkKGuz622irk78ys/S/dM+BRChqiQ/G/na/XL3rGfkHVi328jVdFq3JABR
reDTa+IZL5ax9pvmKGSeuNy/EeaALyNOukBjBe84djzwFFOxYI+DtpeRzOyr8Vsd
q7xjip6RlBNyO6OIPTG5UCrpM0QUXlQIKMqsKRm0cOfRsS3BG4HkEH6rhp6YhQGt
ksoAjlkN79hBIpTrrc1d
=phtQ
-----END PGP SIGNATURE-----

--=-F4KHZI2MzUL7xwT3xAJk--

