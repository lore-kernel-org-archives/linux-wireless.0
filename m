Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:46242 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934232AbZLFV7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 16:59:34 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/4] nl80211: Add new WIPHY attribute COVERAGE_CLASS
Date: Sun, 6 Dec 2009 22:59:40 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net> <200912061945.53225.8an@praha12.net> <1260125366.3461.24.camel@johannes.local>
In-Reply-To: <1260125366.3461.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart23346576.HN1gQd47eV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200912062259.40177.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart23346576.HN1gQd47eV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 6.12.2009 19:49 Johannes Berg wrote:
> Umm, no it won't, that's only with your specific mac80211
> implementation. Try on rndis for instance.
So I looked at both drivers that define set_wiphy_params: rndis and=20
iwmc3200wifi. Both ignore WIPHY_PARAM_RETRY_SHORT and WIPHY_PARAM_RETRY_LON=
G,=20
so WIPHY_PARAM_COVERAGE_CLASS is just another parameter they would ignore.

Anyway, I don't mind adding set_coverage_class to cfg80211_ops if you think=
=20
it's the best solution. It won't change the netlink API.

Lukas Turek

--nextPart23346576.HN1gQd47eV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJLHClMAAoJEEBjvk/UOfYwY20QAIV+GXHX8iiXzw2C/ppiXFhq
9C7AE1TtOHGlmTywX5sypApyYKGAwC7vv71883ZEfp1FUuto5qN5615uS3xwiE75
NsJzU6k0JWPPW5NgAMdngRjexvDKmhrPg0ACy2gmkBYfTKkcaUKIM7Snv7yc3mdM
enNSGjUyyoOHbmUHqeXn9/33QV/kj80IecMQPR7EQtq0zQNnpEJ4VoQIz1dFEf5g
L9wcNo/d1i5f8rILdK9T5EYiqsmgB4fii9WFqVgqbhFbteue/WDNkLLNQg/251ry
y78Ex7cqW/o79QfQEXKodu7xLAppomV1EvCt4fqc4Hevb3IKY0qAjXUt+nCZ99Ff
PwdJa7/ho22AO14RlKhOK7Gb3t0+WlZ6XL3xJQT6xk2Hw0+2V2wNaLG+X54d74Pc
X1cdiMp+MkiRaO+8UVx9N5Rp+tzkpCZ6pysvZqB5IZWITWsE+K3r8tqiNfb6TZbK
wSOxC/Mr8zsu2mD3DiaHNZSI1UxA13pSYq5skYErl/cRvstCfYwH/s3Q7gbtm0FY
tsa5NlCg6rAO7bQ7tJPye9Loc6bR+I/XBOw5YIIoLTY7m3fHAJms7lwMBg6FWEYu
30luNsvpK27bLuiNlg4qdc9BJ4SzIoFK/1R086ma2xUv0tLU5zsR4p0LirDj0Ato
aDDGm4+O1WkeCP0uX2vm
=WGIB
-----END PGP SIGNATURE-----

--nextPart23346576.HN1gQd47eV--
