Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46859 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZKPS5g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 13:57:36 -0500
Subject: Re: iw [PATCH] update to latest kernel changes (mesh)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rui Paulo <rpaulo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1257771187-7894-2-git-send-email-rpaulo@gmail.com>
References: <1257771187-7894-1-git-send-email-rpaulo@gmail.com>
	 <1257771187-7894-2-git-send-email-rpaulo@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-e7varSWYs2tiz32ScI5X"
Date: Mon, 16 Nov 2009 19:57:41 +0100
Message-ID: <1258397861.32159.37.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-e7varSWYs2tiz32ScI5X
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 12:53 +0000, Rui Paulo wrote:

>  mpath.c   |    8 ++++----
>  nl80211.h |   11 +++++++----

> -		[NL80211_MPATH_INFO_DSN] =3D { .type =3D NLA_U32 },
> +		[NL80211_MPATH_INFO_SN] =3D { .type =3D NLA_U32 },

I've kinda taken this, but it shouldn't have been necessary for
compiling.

Please don't ever again make API changes in nl80211.h without keeping a
backward compatible #define and noting so explicitly. I'd also
appreciate a patch adding the #define DSN SN just in case there are
other tools using nl80211.h and relying on it already.

johannes

--=-e7varSWYs2tiz32ScI5X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAaCcAAoJEODzc/N7+QmahTUQAI1xFdTBhhX37vTqxuTSwQ6d
qhpj5uq2MEd8XuJcLxkNgQXfyTtYYAG81MUdm8MwQ+8MZsRuPuoaSvSJ/YaB4SGE
Mluz5COHD5xebqjy/PdshqNzPafyN9BBTcwj6gONbcYIzqPFx/JX/tzbN72R3eWQ
4rnI54oewGBLGTQRXuDXZHVjKepKUcyXDfQLcZ+Ee3J2xt4tNBBCrheG+QV/c6v0
CgKPjAJtt9u+7VfUWYQroWdE4ygSnY8xilgktCtrOEDjvwpsgo4yvJC/YlkcnK4m
X8jGMOPBo1nINtI8WDAaDhBgdOql8gxiM9lqiRRXZroMMezuDrft5e1aMQ/Zom52
PsScfH9YmVh9oJsCoEAdEFLFLF6W0XDequpJIlb1s+uSYqkxgd7NuHHKfh4orSKs
Aun4+mnFEXKjTUjkogEX3fUVqA0pJkGlMePciC1ddS+fkRHBNl07Gdaij3U5DQCo
if1ZFA+bTxLCEylrbfYQMRHad2vWpHaMJ2gabnVgjVNcAOUVYHEcOwabBGzaIvnb
EPp0P/b+LyHu39nXqcJPL0Gm7wjE8nHo67IWHKau36eynJKEgvAwYf+x2sLVrlBv
aw+307IOM15MdgjK4WJQMq+kSvVJcNr1mVEgeLsei6RP2O4SEDloRz4shN1lyRao
MU3ZxBK+g8tvdlqjFrU4
=iAZI
-----END PGP SIGNATURE-----

--=-e7varSWYs2tiz32ScI5X--

