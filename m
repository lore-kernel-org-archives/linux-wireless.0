Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:36647 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750854AbeELD57 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 23:57:59 -0400
Date: Sat, 12 May 2018 13:57:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?=
        <toke@toke.dk>, Wireless <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the mac80211-next tree
Message-ID: <20180512135757.7c4e3bc7@canb.auug.org.au> (sfid-20180512_055812_972727_E3149DC1)
In-Reply-To: <20180509145624.643d2e56@canb.auug.org.au>
References: <20180509145624.643d2e56@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4NiqZE+n7_0ITHj05L_/v63"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/4NiqZE+n7_0ITHj05L_/v63
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Just cc'ing the wireless list at Kalle's suggestion.

On Wed, 9 May 2018 14:56:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi Johannes,
>=20
> After merging the mac80211-next tree, today's linux-next build (arm_multi
> v7_defconfig) produced this warning:
>=20
> drivers/net/wireless/marvell/mwifiex/uap_event.c: In function 'mwifiex_pr=
ocess_uap_event':
> drivers/net/wireless/marvell/mwifiex/uap_event.c:333:1: warning: the fram=
e size of 1680 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]
>  }
>  ^
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function =
'brcmf_notify_connect_status_ap':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5530:1: warni=
ng: the frame size of 1680 bytes is larger than 1024 bytes [-Wframe-larger-=
than=3D]
>  }
>  ^
>=20
> Maybe introduced by commit
>=20
>   52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")

--=20
Cheers,
Stephen Rothwell

--Sig_/4NiqZE+n7_0ITHj05L_/v63
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlr2ZkUACgkQAVBC80lX
0Gz0mQf/VZUkfeVvkvAWDWJDLTYgq5Yk9Q64iaVZDnVFlxOYVjsBUyGrxPylIMFo
AQ5ubLlp7+M0NUqBCXtjoeq8ivRMvKLFuuUxFUW5ywy6hfI2Hzai7x7IxaRo7lRC
2VXRMWBHsqpVh2gsPLZwm4rO1humWvl4xIE7u80hfqhZmnlNybxQF4D+1oe8jD5H
4Hsp80sNIaRqAJnqfISq8FwGKQcGRLW2Xr2aKdqTS7ALGqTwqqBx4k2+p3nq+p4l
WO9fNPutkIzvV7oO91HkkG9W6d3N9sxJ3kSVhYT+DuYKKrZVM/xn8b3VeXPeA+EF
m9c2VKNdSZ5T5ry/BTIxZxyVQVtCZg==
=P+Kz
-----END PGP SIGNATURE-----

--Sig_/4NiqZE+n7_0ITHj05L_/v63--
