Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B72C282CC
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 20:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3401A2145D
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 20:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="JqZ00hbn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbfBJU2T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 15:28:19 -0500
Received: from ozlabs.org ([203.11.71.1]:33169 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfBJU2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 15:28:19 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ozlabs.org (Postfix) with ESMTPSA id 43yL8c57d5z9sBZ;
        Mon, 11 Feb 2019 07:28:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1549830496;
        bh=31VLEiluGFa3vuZq2kXP3V73Hjyx9SPv7gNM9CJ0Ios=;
        h=Date:From:To:Cc:Subject:From;
        b=JqZ00hbnLTbVfBU8iLl7y4BbKUj2NRTSBNMD/7EZLBBuxwZ+6mDMNeXe5dGjU0u4S
         MYuNzl8UL0t32tRLgTkdVnB2McQwMjM8uCxbvprXN4G6o1LKM+hN2c1imyWponVNTL
         K3nVgJsR9XobXZwrcKP7ZCklTaTu1oMNL2mjMv2nzkGUGe/G6pHrDZdWDzqgXoMJKK
         GC0sgN/M+G7QcuyiTnqgElODnsJQJjwd3wlgWPYTpg5+HU+/QN43merWa2SP1qBV2D
         dgl4NuPp9l+gja/tujOunz3LZBI1cnQQPjnoq9BwPLyuhIr3Xnq40ctOyD/UttBZDA
         j0GurHhlQ/8iQ==
Date:   Mon, 11 Feb 2019 07:28:14 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>
Subject: linux-next: Signed-off-by missing for commit in the
 wireless-drivers-next tree
Message-ID: <20190211072814.7428f192@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=+Vr7I/S+AR2Prk0XMPrTzU"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/=+Vr7I/S+AR2Prk0XMPrTzU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  768ec4c012ac ("ath10k: update HOST capability qmi message")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/=+Vr7I/S+AR2Prk0XMPrTzU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxgiV4ACgkQAVBC80lX
0GwsJwf/Sk4k8MDS7E608Nw9IgJtE3R8dJMNktgQXGUawWGRVhVrKq2ytWodo8Bf
0ymEvLu8UA6r3MDjqWu1GsGemPzzUa7T15RYxpKp7PXpILE/R4R+rd0w//FZpO34
abwO4Bb32IqdP3ZtufHJxcHYDkaqTyAD9PZcpxkMa5kZMZruBb8AC0HDFpOIvsuw
yUAKrQC6Cw5DxpNXS9LKqDOOkuQtPp9iQM7/GpZVxQH/GuxDYGNfGUpR66OPdY1p
BFiXs5+z0Rmhx3teSAtfIkJaeq/qU6DWhVF+4ddlzfwIV6OeYgzhU9OQ6UfNnfRK
sn0XQy3gIfDNDQ4m5TalLNnrndsIeg==
=w5QZ
-----END PGP SIGNATURE-----

--Sig_/=+Vr7I/S+AR2Prk0XMPrTzU--
