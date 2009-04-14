Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZDNLtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 07:49:23 -0400
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
From: Johannes Berg <johannes@sipsolutions.net>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20090414113928.GA20470@storm.local.network>
References: <20090414105200.GE25746@storm.local.network>
	 <1239707258.4778.3.camel@johannes.local>
	 <20090414113928.GA20470@storm.local.network>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i0Ed4gW1EoJ+y2GI0Xw5"
Date: Tue, 14 Apr 2009 13:48:47 +0200
Message-Id: <1239709727.4778.6.camel@johannes.local> (sfid-20090414_134926_550622_27507293)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-i0Ed4gW1EoJ+y2GI0Xw5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-14 at 07:39 -0400, Forest Bond wrote:

> > Can we also please add files here saying to not bother the
> > linux-wireless list about this crap?
>=20
> I would assume this is somewhat implied for any code in drivers/staging. =
 Is
> that not the case?

It seems to be on a per case basis -- and there's one driver at least
(agnx) that we actually do care about because it is there only because
it's incomplete not because the code is in some way problematic (like
using its own 802.11 stack)

johannes

--=-i0Ed4gW1EoJ+y2GI0Xw5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5HgcAAoJEKVg1VMiehFY3WcP/RHX1yVgf20nS+5UIdjRL370
DBNSQcXdrZhU6upNNS45poaR7yffs8uyJtAJZe35keshMdmP2yxqSkEn/I/4r1Ux
/NvWTYY8ArdeJqIV2QIYvuzHYvAUYeC9QK/PGvwuOTJeWjo/8COaVTc4w/GJiNOC
FtainpEkV6ZFCWZ6/0JuCH5i2JpyQ6DO35aFu7BG4TlN1kVEyWsOoL3wDHUyRG6w
3cNJ+oxOebNUX1jFALST15hn6GeFmbQrD9M5653KAhTfm4/KPU8HSGecGflB7NIt
erWTS9n8gsWtxEwJgfmgeDt6c8/liOuVY4uDmYhBQ/Ma3emP1+GwOqABFAwK8DLS
unNmCM/tz/JSGajiWUeitRVFqSj2yT+mYUvd+dN/CDXBkpAsxKsmdLEyTaFQPku7
wx+guEcEWjUC/Vz0m2BQ4aTfbMgk+0LPHhttjYpmP+f6eyZzd75bENjcqItzb33E
zk0CJsMRfsTXzb166ZQQ6kIpxqjcbnUeL9tBscqUqPOCqa/cCQz46yJFv4Ne/7zv
FRQ45m+vnfVvdya8366cNMPxUKlU1tIoK7RIImzIEJFqrpV/ImGyCcZtRNluRNAk
aasHP6G3WiPZlGzAEDfzXxFIQcH+s4T6NMSkbHmlXSHTd4/OCTx1XmGlOViJLObj
RrW3KzcibaiRDtkQOTKn
=4ui+
-----END PGP SIGNATURE-----

--=-i0Ed4gW1EoJ+y2GI0Xw5--

