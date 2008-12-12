Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYLLVsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 16:48:09 -0500
Subject: Re: iw Makefile patch to allow compilation using --as-needed
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Auty <mike.auty@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4942D853.10105@gmail.com>
References: <4942D853.10105@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mUWFMhdpZALvc3yXsCx9"
Date: Fri, 12 Dec 2008 22:48:02 +0100
Message-Id: <1229118482.3572.0.camel@johannes.berg> (sfid-20081212_224813_940066_F284E17F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mUWFMhdpZALvc3yXsCx9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 21:32 +0000, Mike Auty wrote:
> Hiya,
> 	I've got a patch for the iw program to allow it to compile properly
> with the --as-needed linker flag.  This flag requires that files and
> libraries are listed in a particular order, with required libraries
> listed after the functions that call them.
> 	The original Makefile for iw adds the libraries to the LDFLAGS
> variable, which is processed before the OBJS are listed (so the
> libraries are removed).  This patch adds a LIBS variable and applies it
> after the OBJS variable.
> 	For more information on as-needed, please see
> http://www.gentoo.org/proj/en/qa/asneeded.xml.  If you have any problems
> or issues with the patch, please let me know, thanks...  5:)
> 	Mike  5:)

Applied, thanks.

johannes

--=-mUWFMhdpZALvc3yXsCx9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQtwPAAoJEKVg1VMiehFYvDYQALks4BfDcYHXgajrGg9XaGCf
hmPUdCp+cycqYJcmjDa0vtjDgziS/f3ZmLuw2hR6K2pGK5trIu0lfjRO/Fpc1V/g
q0v8Ve/6vmrfISF5UAEczmTBZBnc04TtAbVwKWMzH6/GEd4ClNy9HUwKq2W4KB6f
b0MeuCkb369hE8GTqhgu+FjyY/cYNj/bt4ec1UQrfHJUJEZRE3MRHxymLwt/2OtQ
4OckbG2K4AfhkapTtCDEpHIdoPeN6UXJSwclGqQnJ4hfBkViw/EaaHm6qbYnhCCx
NpQ7jwGxSC6muqtDcKhiZOf4SrJ8guVPy5k6yGzPFadU/li2m2C/ZRtfzaxCxTdX
WQIXm5WfDukPZTNHpf/F/6uKeJL2ZX8AkCiV++6nH8bYYjo72X/2DZNYoP676wob
Rp72Vr0snusYGEj5seChGHhoOomHs+NTbtBGFxvioK8i46ga0e/w/X1or0uNUIbb
9MqplVfggRLfcJpwTamd0rBF1iBoWAcIHhMhUifY+7CaSFcg3xQrdZzifL9/V/d8
53YyiNUlpUqkM0dmkwWTgSr5mkcrwQa9BFfs1x6UflHwlfPg4e/0F83/ci3A9Rp+
o2+FfLrFvmro1up/WSjQ3croc6rro6iP1wS/wEKFpzo/+cyyk+nKOzlz5XyRnPxB
m+T94ZPe/GxcHG8J2lOM
=xI7F
-----END PGP SIGNATURE-----

--=-mUWFMhdpZALvc3yXsCx9--

