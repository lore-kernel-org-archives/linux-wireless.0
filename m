Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932BAC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5809C208AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:32:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5809C208AE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=simonwunderlich.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbeJAVKe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:10:34 -0400
Received: from packetmixer.de ([79.140.42.25]:42640 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbeJAVKd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 17:10:33 -0400
Received: from prime.localnet (p200300C593D534007D4029BE610426A8.dip0.t-ipconnect.de [IPv6:2003:c5:93d5:3400:7d40:29be:6104:26a8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 4673462018;
        Mon,  1 Oct 2018 16:32:26 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/5] ath9k: fix reporting calculated new FFT upper max
Date:   Mon, 01 Oct 2018 16:32:25 +0200
Message-ID: <3368586.snalD90uim@prime>
User-Agent: KMail/5.2.3 (Linux/4.17.0-0.bpo.3-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <87wor1kab5.fsf@kamboji.qca.qualcomm.com>
References: <20180919103711.19304-6-sw@simonwunderlich.de> <3916789.BTZ6ITeYER@prime> <87wor1kab5.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2103920.xWEPGNC1g4"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart2103920.xWEPGNC1g4
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, October 1, 2018 5:31:42 PM CEST Kalle Valo wrote:
> Simon Wunderlich <sw@simonwunderlich.de> writes:
> > On Monday, October 1, 2018 2:07:55 PM CEST Kalle Valo wrote:
> >> Simon Wunderlich <sw@simonwunderlich.de> wrote:
> >> > Cc: Nick Kossifidis <mickflemm@gmail.com>
> >> > Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> >> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> >> 
> >> No empty commit logs, please. But I can add that, just tell me what to
> >> add.
> > 
> > How about:
> > 
> > Since the debug print code is outside of the loop, it shouldn't use the
> > loop iterator anymore but instead print the found maximum index.
> 
> Perfect, thanks.
> 
> > Let me know if you need me to resend or anything else.
> 
> No need, I added this to the patch in the (not yet pushed) pending
> branch.

Awesome, thank you!

Cheers,
     Simon
--nextPart2103920.xWEPGNC1g4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAluyL/kACgkQoSvjmEKS
nqE1Fg/8DNzxehLk4ZTwSUr63nnuew2ycdu3eFqol6w0w2++TPnhF4NmJ3PUtU4N
qFoBRAYFAidYzMpqCZUUfztI9l6rgyV54pTp7nk/br28dxfmnZ0K1E91D0VSI1V+
s7+GwQy6bdFhl71Y6yiDku/nLBWW9AykKaDO7Oc2+jeMAjwH8r7Ia2zYn6Td7BzF
5uu8XC0PJstt+FCl+i3J+ggUs7BZqPmOx8fgWH6YByXAxtgVeRt8OiWptJS4iNKy
Lv/fcBBCiLLiT2udim8PeNLo1uNl9yPZNuTrfpBVUtJ2Ylk/HzdxhxL5PuWAOvrY
ae8n0eqxsgCSJ5mYAuMoOAioyAic2kJf6dfCQPy5Bu72234ruCMcm/sRFFEwThDz
hxwywtjE9TNOcacNvPrDNhc7hfNsxJXMi6fHP4clB5aPOAu9du4Jv9nwSeOJQ95S
GyOuBwSe6BhkRG0EVd/8K43vIddjeXNewE0RYZsDbfeHOVRUAkSgw9V61GxoRzAO
xo82cXH6Pu+hbsAIDiCPH4wdum9QJycs1JGgjgHGw9qKu4yhlKEJKdbbdsBbda4j
qLQtVKDenIrBnldJpq25YBUbiJ0kssr76g+C4GswzsExEaUwXcaOda+x0TyVG/w7
A39jtlJogiYN6aVa0oD+t3nAs1P1zSNRvaGc/Q6sEBRDFx3sjYk=
=ITsa
-----END PGP SIGNATURE-----

--nextPart2103920.xWEPGNC1g4--

