Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234C1C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:11:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E87FA20663
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 08:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="rWJYilsp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfDIILU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 04:11:20 -0400
Received: from ozlabs.org ([203.11.71.1]:51843 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbfDIILT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 04:11:19 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44dg3R194Yz9sPq;
        Tue,  9 Apr 2019 18:11:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1554797476;
        bh=eupNKMgd4Wpa3yAsK0icR1nZVRngo3+j2JVo4Um2B80=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rWJYilspZkgVFBEQEub0OUfn64C+wMUug2mBKvQ3/uZuz1tUSkXld3o/PGscDiYIB
         sdpzYkQRqlgtCzjjK7Sz/EfOhiaJAPSxy6i0+qDy4KclQ7K9SFrZgPIvnI0j+TIAXf
         uKveEdXswHiLYU2cbEsanskBWPDwTcaMckRwNnNnQyV0JnRBJe4lrp90g017nME2/S
         g2B5UZ9cra8BkXIg8Q+ZnTy06Bfhbh/QWQSlwE52zGMPPkuHDiH7JviQ7j2xp4liuc
         YoLKOpL4YD4ujU2yKImWK9m5nO0FFk1QuxgB5EbP2JtEintJrV/SyFM+pBil2+Pu2D
         0S8it+KOOacXw==
Date:   Tue, 9 Apr 2019 18:11:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the mac80211-next tree with the
 mac80211 tree
Message-ID: <20190409181114.0513c896@canb.auug.org.au>
In-Reply-To: <7deebb8e8c82e4455af8fc4963ffc7acca3aab36.camel@sipsolutions.net>
References: <20190409110607.29df3cf3@canb.auug.org.au>
        <7deebb8e8c82e4455af8fc4963ffc7acca3aab36.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nBkp4e3rMK.6Roc4=v3h8wr"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/nBkp4e3rMK.6Roc4=v3h8wr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

On Tue, 09 Apr 2019 09:27:35 +0200 Johannes Berg <johannes@sipsolutions.net=
> wrote:
>
> But yes, I'm aware. It seemed simple enough though that I decided to
> keep it like that, I didn't really find a better solution.

Yeah, pretty trivial.  I assume both trees will meet in Dave's tree at some=
 point.

--=20
Cheers,
Stephen Rothwell

--Sig_/nBkp4e3rMK.6Roc4=v3h8wr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlysU6IACgkQAVBC80lX
0GwovAf9EXARDSIHDX0A95Nbv7THG0BTJ6tgMCTuINOXIwYPWzdpAFDUVVrAJM/h
pio4swOqexjh7EpvzqyOukkGopXpeVLrg/ucgqjYEpxMIWzCvE22+6qOHUYfmpMD
ljjUF5di7sJ577DcOkq82ouxBGzxmZheIdgpxDcLPR5DCsl4+oqJvI/Ck3zVOo2U
nvbMzgQsuSZlkSupc9RNZPCw9TgVEfEAFx7R4b/5JUHsNDOdCNQhsjFziib9HnXO
TjxtrFQxzvIvqgcSGZuJVRAxrhJaTRiHat0+G1hR8EJ1H0MWgR28OsSLCdLQyrzu
l3JEH5ML/+oWkEI8ZsgMF7/9o1Vbdw==
=qsV8
-----END PGP SIGNATURE-----

--Sig_/nBkp4e3rMK.6Roc4=v3h8wr--
