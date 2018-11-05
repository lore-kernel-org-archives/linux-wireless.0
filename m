Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347F8C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 21:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F353E20825
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 21:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F353E20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bues.ch
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbeKFHBK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 02:01:10 -0500
Received: from bues.ch ([80.190.117.144]:45112 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387580AbeKFHBK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 02:01:10 -0500
Received: by bues.ch with esmtpsa (Exim 4.89)
        (envelope-from <m@bues.ch>)
        id 1gJmag-00060o-FF; Mon, 05 Nov 2018 22:39:22 +0100
Date:   Mon, 5 Nov 2018 22:39:09 +0100
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     Priit Laes <plaes@plaes.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>, b43-dev@lists.infradead.org
Subject: Re: [PATCH v2 3/3] b43: Use cordic algorithm from kernel library
Message-ID: <20181105223909.61860cdd@wiggum>
In-Reply-To: <77709642dacd9d855618bd9c2f3a56a88e881eaa.1541446422.git-series.plaes@plaes.org>
References: <cover.9ec98292c595a111ae78f31383ff8618c9cb04da.1541446422.git-series.plaes@plaes.org>
 <77709642dacd9d855618bd9c2f3a56a88e881eaa.1541446422.git-series.plaes@plaes.org>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/=TxR.mRkCm2uX+V6VXlLC0t"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/=TxR.mRkCm2uX+V6VXlLC0t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  5 Nov 2018 21:37:18 +0200
Priit Laes <plaes@plaes.org> wrote:

> Kernel library has a common cordic algorithm which is identical
> to internally implementatd one, so use it and drop the duplicate
> implementation.
>=20
> Signed-off-by: Priit Laes <plaes@plaes.org>


This looks nice.
But what is the testing status of this?
Has this been tested on actual b43-LP hardware?

Is the replacement algorithm exactly the same, or are there slight
differences (e.g. in corner cases)?

--=20
Michael

--Sig_/=TxR.mRkCm2uX+V6VXlLC0t
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlvguH0ACgkQ9TK+HZCN
iw4TGxAA3rEjXSOKh/BC/zHNPYbmSGUHFPEwXSowS/EDt+0F2YwEpWEXzVGQOgiT
qBxKLLcy5TyJ430lv1D9u6f0lVVyUz1sPTquT5NmIiktE7UAc4RP8w6ACbtI9OZ2
4zqsF2G15mkzE8oilxC+EI/TlLKsli4pKTWgpL+UoShSRnG9cmFbUcbi/kzW0RbC
7ciXgbqv/eirZcTREniI6e0/Qllst5NTlLLyBgXTCCg5hwLgBzO28DiJZR3ynGUD
xPyyZ1NV+IfiueTCgF8DyFka1OA1uvAMsrVh8JDG1DXDlAaaS+bC8R/OUWymovcv
5+f1SbzN/ANFLzTaNzd0vle9Te4V+OY/UcytZlg1Ijlud5YRsDm5ThnzM7MVDPTa
3gfddvjte9PS+SDP4K3KcFUpnK6eZ0GuHJ1w6TEit3LAmjTxyuTV5x3iBUc0cnC3
robcDI+XKUFKj5V0Ze5GOcuZ/L1kvMTSf6GR4QWrHC2k08WTNttvgcn2zAa1qPX5
zZK0DdnMkBfUrM1PJqTrfMb6O1N+/xMlupwyGJs90pzaWdn51vrBFzjy+0O7jwTc
cte2lVIec/Oy6oN5ohjkm5aPv4DGjf2q+UVfANjpldvWpG/GfQ5yG4Ip26f7XcKT
ucrVAJlhgNl7jFjxdrKiqaBMEsr1Wk3jUthIJFdbwaciTBJDNGc=
=Q3Le
-----END PGP SIGNATURE-----

--Sig_/=TxR.mRkCm2uX+V6VXlLC0t--
