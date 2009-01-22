Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZAVNAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 08:00:14 -0500
Subject: Re: porting open source mac to linux 2.6.13.0
From: Johannes Berg <johannes@sipsolutions.net>
To: Bharat Bhushan <bharat.b.bhushan@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <d9360e520901212124j7bf196c3sf4e29d8fd3650f9b@mail.gmail.com> (sfid-20090122_062501_812729_9A829B2C)
References: <d9360e520901212124j7bf196c3sf4e29d8fd3650f9b@mail.gmail.com>
	 (sfid-20090122_062501_812729_9A829B2C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JBWwQrS2MRNa7YjxbU6H"
Date: Thu, 22 Jan 2009 11:53:26 +0100
Message-Id: <1232621606.30174.16.camel@johannes.local> (sfid-20090122_140020_481648_0FBF850B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JBWwQrS2MRNa7YjxbU6H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 10:54 +0530, Bharat Bhushan wrote:
> hi all,
>          Is there any possible way to port open source mac stck on
> linux kernel 2.6.13.0 . Problem is, i am using a embedded platform
> which is supporting only 2.6.13. 0 and now assigned job is to make it
> working for open source mac stack without porting any other changes of
> linux kernel .

First, read Holgers mail. Then re-read it. Then cancel the contract with
your embedded vendor and find a decent one.

And frankly, the effort to port 2.6.29 to your platform is probably less
than porting mac80211 back to 2.6.13.

johannes

--=-JBWwQrS2MRNa7YjxbU6H
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeFAiAAoJEKVg1VMiehFYdFEP/0uzZ0oeNE8sE4L5DyFxnRTf
hzxQF2xJUcqKOa1H98BC0FSuRD/z+QbgkYFg8LwJle0M6cGWSWUYLORczOwlgVju
Sv9bwXzG4y9YBB08bndyY1/cbfxCTV7+bPfNSr3Vt6SPclds5xSsajD7M8sM6tHy
ZKKCyI6Ji7tLvUB0LrvTOvygvcNZJT+cQsM4lSN+9PwO/RMwTbxMa8u/EFntl7aJ
rcRmbacfqORKewAOckBmARhquahjLnwyzWiVObV9fDalyevJk8zXFnTcB7cHt0IP
haGJMtK94LzVnKhqMpwoBm1OaYlI30YkPDI84ia84ZBornSNyKBDym0Vnfdjb5JP
VmNNzAfdLWQhCBDukxxcnuX1YyeTxG6ON+Ddrlit3DaRDDpR2siXUqa62d6cGtEb
B/eqqBvfWuA1G+t4AJ51TbeetUJdMu0gwr2kgwk2EWBZV4IpH+bsWDzXVCLLb7ki
C5+/7Mp5DCsfQaRqM/dmPCqVO0n0mcLODuzoFU6F3+dvLKkat2wywZJ7yEsjN3JP
QAEge9AutbmsdCz0dvTLB0zmdC4jtMToKP2wKXfhXEgMpR8RyxuvZgiV+U+t3sRZ
MZB1ryY7C0GSNXXUyf8e32UtmYr7//hgdWE4JmInSvdivJMim78mq10QFAk57bIU
9xxCuxCB7FzhFExIRNbt
=iK1U
-----END PGP SIGNATURE-----

--=-JBWwQrS2MRNa7YjxbU6H--

