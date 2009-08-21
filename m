Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785AbZHUMkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 08:40:12 -0400
Subject: Re: Abour linux driver supports BCM4325
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: feng tian <feng.of.tian@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4A8E8F59.9050706@lwfinger.net>
References: <f42a38140908202319y5c352aa3s37fec67e5cb8d7a3@mail.gmail.com>
	 <4A8E8F59.9050706@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zXzSimcglF43eYwWLcBv"
Date: Fri, 21 Aug 2009 14:40:09 +0200
Message-Id: <1250858409.5137.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zXzSimcglF43eYwWLcBv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-21 at 07:13 -0500, Larry Finger wrote:

> > We are working on a project which supports the BCM4325 linux wireless
> > driver. The interface between the BCM chip and SOC(pxa310) is SDIO.
> > I did some searches online and found that there is no available driver
> > for this chip. Do I have to implement this myself? Is there anyone can
> > provide us some related materials?  Thanks very much.
>=20
> The code for the LP PHY, which I believe is present in the 4325, is
> just being written. At the moment, the chip is able to receive on some
> channels, and may be able to transmit. These results are reported on
> this mailing list, and the code is being applied to the wireless
> testing git tree.

Also, somebody is working on SDIO support with Michael.

johannes

--=-zXzSimcglF43eYwWLcBv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjpWlAAoJEODzc/N7+QmaY3sP/2YvP0TKbes5oQyHWG22rILM
ErdP/XJLyQo4Lny28TZTgTzRcu16Q3CEegxU+0OsWWv3ZfCUrlPI7lmUz8vXEHfQ
q9nUdMvOArSzizXnIsc1lh87kVKiWc4OwckcKdnKGwjqTsx7pvE+avZ5ezz2QbIX
LTmleKs1as35yfwnkP8PbvMaTib7fkouKd/2zbYkiFQsZGTDex/L2r3TiLHX/eoG
efkAycJ/2wLfbl9OjLzEtv0IjWk/d3+MTvIYQ3c99+PsetqQAveUKVUFp01xAiwc
vSbHdttLxINHJyZ4hYhgj3R88+DgfR8QQkQWwHLdpzZsIioGBSyoQSc3mtymSn9C
DiUPxILFgMT2BbV5I1CKD8jDWaI29XLoIBqjOiRkK6K1qUqyejqAx68XWF0+1Vdr
TZaER/bp80yu8/Q3HeT/msljW8qVnaVnbthgGIf/cXuwvSbCTlXF/0ZDuyBT5fBz
l07mfhqZq/ihezvjlxT28c6VdXds0pNI1jzyOawmxx/PQQbWt/fwgAkUUptWW2N2
aTmboKCyIX9o6Q9gsxt4fCFTwjPhT2XY8HHoBUWGmVi21vkkVNfJOFLG0niE6mSv
zAHSk8GF9+bNyMoFNanXfP0NMAe1FzdinCChL2aVa7i00bThj88BDoIqIfXQY7a/
QGwD0VTQBWfC0W3xxi/O
=udGo
-----END PGP SIGNATURE-----

--=-zXzSimcglF43eYwWLcBv--

