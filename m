Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0D2C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44066208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44066208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=simonwunderlich.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbeJAVE6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:04:58 -0400
Received: from packetmixer.de ([79.140.42.25]:42602 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbeJAVE6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 17:04:58 -0400
Received: from prime.localnet (p200300C593D534007D4029BE610426A8.dip0.t-ipconnect.de [IPv6:2003:c5:93d5:3400:7d40:29be:6104:26a8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id B323162018;
        Mon,  1 Oct 2018 16:26:51 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/5] ath9k: fix reporting calculated new FFT upper max
Date:   Mon, 01 Oct 2018 16:26:50 +0200
Message-ID: <3916789.BTZ6ITeYER@prime>
User-Agent: KMail/5.2.3 (Linux/4.17.0-0.bpo.3-amd64; KDE/5.28.0; x86_64; ; )
In-Reply-To: <20181001140755.6242260128@smtp.codeaurora.org>
References: <20180919103711.19304-6-sw@simonwunderlich.de> <20181001140755.6242260128@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9801026.medzVhJ8Nl"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart9801026.medzVhJ8Nl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, October 1, 2018 2:07:55 PM CEST Kalle Valo wrote:
> Simon Wunderlich <sw@simonwunderlich.de> wrote:
> > Cc: Nick Kossifidis <mickflemm@gmail.com>
> > Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> No empty commit logs, please. But I can add that, just tell me what to add.

How about:

Since the debug print code is outside of the loop, it shouldn't use the loop 
iterator anymore but instead print the found maximum index.





Let me know if you need me to resend or anything else.

Thank you,
      Simon

--nextPart9801026.medzVhJ8Nl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE1ilQI7G+y+fdhnrfoSvjmEKSnqEFAluyLqsACgkQoSvjmEKS
nqGPWg/+NmGgRC/rS4HWeO6Cr/cBw1+AfO0wRLRpcdmjqdFnfQaiLRB/AG1Ex25O
JtlEs5vt3UpW1VVkP6SpSRrotwQwfz/6lMZdkYI85fTa/5b3Obfheut1q2BqqsVL
pD00K+n6pab82X+n+vWnR5l/lGwJJPcqrY5iP1QJX2gPBk0Upl+1KR/gXQC6pg2H
gi8LZAQEnsR7jufK/TkhY2nwaEcIFkDAf9qZuibQ6vHQevfqsj9Su4q/CcHLRgot
6LpxW31V9nQlibxhErWGlKhOm+XoejN2cqGCC05e3uvQuJRBFKcDT84zVPRld9Vw
WCoXuIqFwb+Hr6DQI7SEh+vyJahdoAZ9NKEQDg+Zn0mx7svdK8I/FrIzOH4Z9izA
oPAPJwQG5ahHalUeyIyR0YOLzhA8/ZEx4qaZ0j/TOT9I0cqJH6Cj6dI9iOy8u00M
LLMgiDvynbzS1g+zDaC4o9CU3UrYDgU9Q1Otj8Fxja6I9DukfCk/Wpt1dJoz4aNr
f4QhHFJ5HbGmF5T890a6zCQzcfza6NX1UKDGTMyXrfoRJ1UXjaHnbi7o2ap/+TKR
tpMqbELfFr9g28ZArLxOzQrzBI1Pmxbyo6Klpl4O260N92PwvKjARa4E7r4ODPll
B85Kh/2Bv8i7HOkp5FVs3/+h2vAkfqfEk136rWXmc1LPphZECrQ=
=cP/Z
-----END PGP SIGNATURE-----

--nextPart9801026.medzVhJ8Nl--

