Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173001pub.verizon.net ([206.46.173.1]:57237 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434Ab3BXPGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 10:06:19 -0500
Received: from odin.tremily.us ([unknown] [72.68.84.219])
 by vms173001.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MIQ001BNCMGEM60@vms173001.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sun, 24 Feb 2013 09:06:17 -0600 (CST)
Date: Sun, 24 Feb 2013 10:06:15 -0500
From: "W. Trevor King" <wking@tremily.us>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [RFC 12/13] brcmsmac: add support for probe response template
Message-id: <20130224150615.GN1361@odin.tremily.us> (sfid-20130224_160624_446400_0BD9937E)
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de>
 <1361667972-22909-13-git-send-email-hauke@hauke-m.de>
 <20130224023008.GG1361@odin.tremily.us> <5129DFCD.3020009@hauke-m.de>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=gWRamliw218YCZO9
In-reply-to: <5129DFCD.3020009@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--gWRamliw218YCZO9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 24, 2013 at 10:39:25AM +0100, Hauke Mehrtens wrote:
> On 02/24/2013 03:30 AM, W. Trevor King wrote:
> > On Sun, Feb 24, 2013 at 02:06:10AM +0100, Hauke Mehrtens wrote:
> >> The ucode is able to answer probe response by itself. This writes
> >> such a template into the specific memory. Currently the probe
> >> requests are also send to mac80211 so there are more answers send
> >> to a requesting client. We have to make the ucode stop sending
> >> probe requests to the driver.
> >=20
> > Should this read "so there are more answers sent to"?
> >=20
> yes there are more answers then normal send out, but it is normal that
> you send out more than one, at least I have seen it so it is probably
> in the standard. The last part of this patch could applied again to
> not receive probe requests any more:

I was just trying to correct the English ;), not make a deeper
statement about the content.  Sorry for my initial ambiguity=E2=80=A6

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--gWRamliw218YCZO9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRKixnAAoJEEUbTsx0l5OMjY0P/0tjlq6jWe5TBJdG2YVDRr2r
b88bWqtGfImxnuLVP/nz/6fTellzJz9BsfJzbT5qT6cBPneeqEc53W+t/LT9Tl26
r/MnV7vKYKjfrW930Uk7wkX+sjOsqG29VqJmgOhFU3S6Wz4urzHLQa0i9OKZceFA
/9smp83Ir1uQW9r7JYO3iwDAhrZnGTrqjVsqoVgPgkONApLuaOFA03TdSOYguW3j
P4VOX28IcjOguqKBi5OTEacPBzOFSuhganfKzsT9UfImNVsRz5CegssrI44olQio
174t676uuCqjwldZzHuq+p71QyqVyyiaIV4vodEAygYWCyQcU9Hjg5A8VEtp+vmB
sIq6zkOp5biIrwOpFf0mzxsYNBcpehZiUMNw1hLQ492GSzGc6ZLwGPT3Ueh/UTvE
AazkKj6nIWxk46zhIleZUNGPcP8kkRjUkZ5aYtT5M+5mgAJUOaiMmX4PewTxwk5C
3yJk51ln9jIdzmhXQ11B9wR8wgQJ2CvTEo4e1gVD2Cc4PlQydWc3uWalIRa/Lp8v
4IxAdjwUsk7bkosW9kczCKwtm3wmboSW++wI2YGqYY1KeSfxIMYGNrp/cmwALuHZ
QCUhWJCUdSKRdNWbXLzDjASZXnOv/Yy1NiZvNGW8SkH1n1lNzRIqrlWKpGlDbMD3
znCaG4zLzwJYuaIeqi0Z
=CiBy
-----END PGP SIGNATURE-----

--gWRamliw218YCZO9--
