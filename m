Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8364DC388F7
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Nov 2020 21:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F350206B6
	for <linux-wireless@archiver.kernel.org>; Tue, 10 Nov 2020 21:13:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="k+yjf09p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbgKJVNC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 10 Nov 2020 16:13:02 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:60475 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKJVNC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Nov 2020 16:13:02 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CW0vH3kygz9s0b;
        Wed, 11 Nov 2020 08:12:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1605042779;
        bh=sqPUYH7dd9Iyds0ql3EubkQqUtQJ/UtFyeEmU/huRUI=;
        h=Date:From:To:Cc:Subject:From;
        b=k+yjf09pMZbFeBpsUA1txnyc9vInR/YdDC5ScmYfy1/ko3N9o3O5Df5wUEkPkkY2r
         YnGyN0oZ/DTO9LqWCODg/LIBCy1D05dR6XWmYlRaRBIJlfsqxgPAved6btcco0aq67
         5ziflbdWvdWkIn1h4s5VjmdPQY+2nJLGgQDpjxDjw6tJS/3PedDVELbTfI3SK+Q4rS
         Z6IHzW02jVrD22+9vSTyThsJjwycp9NauPrAxIKMpCVwv6d+M8o9jaGSemmzXgqLdy
         ejemE9w7UawXSDFFKHVwNiIHwAD01HtAmHPjIJkdQRvyerJFxthLi3D1+cOX/SNsT/
         XcvHpVHOJqQOw==
Date:   Wed, 11 Nov 2020 08:12:57 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the
 wireless-drivers tree
Message-ID: <20201111081257.30418470@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vzn4ewVMJ5LxThH.l=Ihuve";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/vzn4ewVMJ5LxThH.l=Ihuve
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  97cc16943f23 ("iwlwifi: mvm: write queue_sync_state only for sync")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/vzn4ewVMJ5LxThH.l=Ihuve
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+rAlkACgkQAVBC80lX
0Gz9BAf/U+w1IMbizJotCIWGahTuoqE/J5kzYiFSEXG2qyZZde9rwNVU6c5DZ0uM
cSf4F8VlT9dPikB9LiRCtov+4NPWplBfPXx8KxJe+7HEbu/tNbdVGEvm2Db1rhDl
3wQkMGUwrhNlHjJIPL7qq7anH425NS7UQS7+ye6mbN8XOj6yYSfN9jKaSW5hbRIK
Zj+9KEWPARx3cTZK759Gqfi+MZoalTH1Fd+TV9Pep+JAsYc9tpyAy7RlojpUkSn1
y43jAKTAz+I7VcaUdst28mBuDOs2S4+cT3E5Ufybedl4gg84xH+saus1H88P/aIH
L8s8TqUnrolRZ8XP6Cm74rsd75T5OQ==
=ug87
-----END PGP SIGNATURE-----

--Sig_/vzn4ewVMJ5LxThH.l=Ihuve--
