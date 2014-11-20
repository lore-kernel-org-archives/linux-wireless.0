Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:58284 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaKTUzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:55:10 -0500
Message-ID: <546E5510.8090105@telenet.be> (sfid-20141120_215513_337934_EB13DBE8)
Date: Thu, 20 Nov 2014 21:54:40 +0100
From: Ruben De Smet <ruben.de.smet@telenet.be>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom Corporation BCM43228 802.11a/b/g/n
References: <546DE1DB.7090900@telenet.be> <CACna6rzHG+mrTWq55ALSsya+bM7hOuqcwDq0Y-sHcxdHEHphqQ@mail.gmail.com>
In-Reply-To: <CACna6rzHG+mrTWq55ALSsya+bM7hOuqcwDq0Y-sHcxdHEHphqQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="pbKq4jdm51RT1gaKiFtTSi9Bd2GQETXIm"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pbKq4jdm51RT1gaKiFtTSi9Bd2GQETXIm
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 20-11-14 13:51, Rafa=C5=82 Mi=C5=82ecki wrote:
> On 20 November 2014 13:43, Ruben De Smet <ruben.de.smet@telenet.be> wro=
te:
>> This will be the last day I'm using my Broadcom Corporation BCM43228
>> 802.11a/b/g/n miniPCI WiFi card, as I'm switching to a faster Intel AC=
 card.
>> Is there any interest in the linux-wireless or b43 community to have
>> this device for reverse engineering purposes? I'm able to send it for =
free.
>=20
> Did you test this device with b43? Were there any problems with it?
>=20

This is what I wrote on 12 November.

--BEGIN--

Hi!

Today Fedora 20 updated to 3.17 and so I was pretty eager to try b43
instead of wl. It didn't work like I hoped it would; networkmanager was
able to scan but not to connect with my BCM43228.
I've ordered an Intel WiFi card some days ago. So if the b43 team wants
to, I can send a developer my BCM card for free for developing, reverse
engineering and debugging purposes.

(I googled an excerpt of the dmesg error message (because it had a MAC
address in it I didn't want to give to Google), but I forgot to write
down the original message:

deauthenticating by local choice (Reason: 3=3DDEAUTH_LEAVING)

Ruben

--END--


--pbKq4jdm51RT1gaKiFtTSi9Bd2GQETXIm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUblUQAAoJEPgmWogSE9wQjRgH/jGmVRlfVlFk0SHv433RQCZn
a+/fsQOaY3sQOnhoL4N13KoC+hcr65PPwh53hfyoNKT1LJlNkBteXZVrvHOwjL1B
48RTpP9urj3P4LknOB/IMlzwJMXuvKA230yh65tapDO4fWWNv1fFxJl+73t9yxOl
1AanveU2Dal9B3zkQVTJqkkYHnCJ7rEBA5XajP4DKQzQr6TgD2oyAx7oyB6Mm5/n
8bO7f+YJ2ii/uv7JMuW2YSPBri3mCE7Vjcmr6wzSxyG1lFZLpeDUfZ40SxUI08NS
dY3COvPF7O1DDVIQ2LvdTdGwfKFh9tyTbwh4CtxXljd4aLT++4Pqcu2pUub29uM=
=u6xk
-----END PGP SIGNATURE-----

--pbKq4jdm51RT1gaKiFtTSi9Bd2GQETXIm--
