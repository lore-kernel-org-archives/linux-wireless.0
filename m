Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA745C48BD5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 06:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49A320665
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 06:36:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="OinY8xL6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbfFYGgM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:36:12 -0400
Received: from ozlabs.org ([203.11.71.1]:32985 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfFYGgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 02:36:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45XxJ909ZBz9sCJ;
        Tue, 25 Jun 2019 16:36:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561444569;
        bh=dO3XscoVB3ULL4FyvUqjI7h9ZE4QFVv+Xaf7zfDrQxg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OinY8xL6S9cgexWifplyCBWfR40+F1nTj/hsHAD7d0ydyxlNwKTXzTQ0hl+EwzE8b
         SKn8F8ZDnUNwvm2jXLEwl+cA20YwrCDh3dKOEHdeLyoTzuZJRU2AuXsacv3HHXF2l9
         Mt2VjR6cV75uk6a2aBiXPCqKuVGPWjAQquG69zg/llhCoMgoVh6Kzb4PN4P5emAfT7
         wx5r518da8+sSn2iQFUr9IPo9K9TDR2yvY3hfrfm62sO9fmF/YJ5RZMjHblyKRmFMq
         CNlDmm6sWsdfK5HeSIQCYm6OFa1nZZlO/4LZ5AARcspY8mEdzNMINZV3MuvhY9Wno1
         rWGWoS62mVkXA==
Date:   Tue, 25 Jun 2019 16:36:08 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20190625163608.1aa15ad3@canb.auug.org.au>
In-Reply-To: <8736jyfaje.fsf@codeaurora.org>
References: <20190625160432.533aa140@canb.auug.org.au>
        <8736jyfaje.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/i0o.Z3=/4aAT3OR7oT/AH_c"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/i0o.Z3=/4aAT3OR7oT/AH_c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

On Tue, 25 Jun 2019 09:23:33 +0300 Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Thanks for the report. Any suggestions how to handle this? Or do we let
> Linus take care of this?

Just let Linus take care of it ... mention it in the pull request ... I gue=
ss DaveM needs to know, right?

--=20
Cheers,
Stephen Rothwell

--Sig_/i0o.Z3=/4aAT3OR7oT/AH_c
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0RwNgACgkQAVBC80lX
0GwU+wgAktLZUTfdGQuZI5zMr9r9mZX1OdvPdYDZe8Ocw4YtmYWEf1xtWUzKrFi0
EBtsS57iYyJ7VpFemaCVvoeG1qnYU9z0c44+AWOEASW8xPCT6RJ8efQ7AVediiJN
GqC2ArdhrjRJNbnpg48DGM9ftp2l22SZuY/MGpnxJYwIrFIcsbhESoxpGmdpuMnL
2VuM6xWWV3k1bkLFuNECmroFCygOzmrrAPqtowPMLGknIaBFPRDt/c1Z+r597zDD
8WdfamX2I8QwI6its90b1WpT3U4pxaP+2CVjqVvSbTGLqp5tid+ELMQNdHPxpGVr
26QMVG1bBTUvO3hVYux1270fceI5Hw==
=Br3V
-----END PGP SIGNATURE-----

--Sig_/i0o.Z3=/4aAT3OR7oT/AH_c--
