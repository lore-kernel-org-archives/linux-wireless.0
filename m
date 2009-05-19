Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbZESJsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 05:48:22 -0400
Subject: Re: Plan of attack for enhancements for scan while associated
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com, Gaurav.Jauhar@atheros.com
In-Reply-To: <43e72e890905181122w38f83785p2134a5142a9f0905@mail.gmail.com>
References: <43e72e890905181122w38f83785p2134a5142a9f0905@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YhPiGA279/1C5piADX1y"
Date: Tue, 19 May 2009 11:48:13 +0200
Message-Id: <1242726493.17164.28.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YhPiGA279/1C5piADX1y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 11:22 -0700, Luis R. Rodriguez wrote:

> We could possibly allow for a debugfs parameters to allow users to
> tune this to say scan over x channels before going to the operating
> channel, as well as change the time between moving to a new channel.
> This would probably help mostly with tuning this while debugging or
> figuring out ideal default values.

No, why? We can calculate things based on pm_qos, the only problem comes
in if pm_qos essentially says "no latency allowed" in which case we need
to do things as quickly as we can.

> New userspace can simply make use of nl80211 scan on an individual
> freq request and figure things out on its own.

Umm, no, it can't.

johannes

--=-YhPiGA279/1C5piADX1y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEoBVAAoJEODzc/N7+QmaWd8P/iLdZetbsnuU3OAp0dPDZIGD
JhNXG6iff/gcSXhzLd6rUi5LCNfSCoTpTk0X5t+KXywXGeFRoqJHBjz6LYYn2FU3
9uzLzw6tftqFTieGU/z2NckaDR1o/m1uZ/TGqjfAGZAtOgQdbVzgCKroCq+srFeT
RJPTugoHIrLE+dX/b7VLEWgVi9IHXtY6GqtibKNQ11FMVEr7nmzcsknqizbQg0uc
BLCre+d9Ig+E/DZmdPwE5a2K09cmXXRrDim8r7bHVSECxEZ4EzpuQuW19P2+TIJR
Il55RVgZD7NbDE3ZSB2kYUL9FIyORmN/Flaws23fIfha+QZS5dwixfsLwT3I3HDZ
+lF6HDPnBXGbCdMuf1Sv0dl9K4bTjJ1vHRoCsbigdMpNxr6samKO57K0cwiv2fzv
ieUJD2mGf7taijpqVOBlEFTTFzUr4TdQlRRpOXf0bBpNa8h3B9d+sYhJFbuE5VC7
N6aFK47/Yr3Sjg+idr5XoYnvOkRnOsoA2zLPz+Ddlw0j+SPcEFvSZ+cx7tStxuDK
hshx+clQpcDH53i2CpqqliiJTleR27F0obP5058LvIidq3qruZFItNCBsu44c1QC
ei61JUeUTX1bZoj3moLT1DwMxD0GRXpAYxGeSskjSMeUg+hQ1juQg2xBBOzlR/SY
ioSFttZE8lOZwQdHP+Hs
=E9EI
-----END PGP SIGNATURE-----

--=-YhPiGA279/1C5piADX1y--

