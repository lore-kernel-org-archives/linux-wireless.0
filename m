Return-Path: <SRS0=04kx=DV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E75C433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Oct 2020 13:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6696C22201
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Oct 2020 13:23:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgJNNW7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Oct 2020 09:22:59 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:55990 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725944AbgJNNW7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Oct 2020 09:22:59 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.69])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1kSgjy-002W2n-VZ; Wed, 14 Oct 2020 16:22:51 +0300
Message-ID: <c26822c0a6d19869d7eeaa6bf07db1f3298a1984.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
List-Id: <linux-firmware.lore.kernel.org>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kyle@infradead.org" <kyle@infradead.org>,
        "jwboyer@kernel.org" <jwboyer@kernel.org>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        golan.ben.ami@intel.com
Date:   Wed, 14 Oct 2020 16:22:49 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-JzpqeD+PbrpMeQiIQXgO"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Subject: pull request: iwlwifi firmware updates 2020-10-14
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-JzpqeD+PbrpMeQiIQXgO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

This contains some new and updated firmwares for all our currently
maintained FW binaries.

Please pull or let me know if there are any issues.

--
Cheers,
Luca.

The following changes since commit 58d41d0facca2478d3e45f6321224361519aee96=
:

  ice: Add comms package file for Intel E800 series driver (2020-10-05 08:0=
9:03 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
tags/iwlwifi-fw-2020-10-14

for you to fetch changes up to 4f41e9d6437d03e7ce9279076107dd08f46656f3:

  iwlwifi: update and add new FWs from core56-54 release (2020-10-14 16:07:=
28 +0300)

----------------------------------------------------------------
Update iwlwifi firmwares to Core56-54

----------------------------------------------------------------
Luca Coelho (2):
      iwlwifi: update 3168, 7265D, 8000C and 8265 firmwares
      iwlwifi: update and add new FWs from core56-54 release

 WHENCE                            |  36 ++++++++++++++++++++++++++++++----=
--
 iwlwifi-3168-29.ucode             | Bin 1036288 -> 1036288 bytes
 iwlwifi-7265D-29.ucode            | Bin 1036656 -> 1036444 bytes
 iwlwifi-8000C-36.ucode            | Bin 2401100 -> 2428004 bytes
 iwlwifi-8265-36.ucode             | Bin 2409984 -> 2436632 bytes
 iwlwifi-9000-pu-b0-jf-b0-46.ucode | Bin 1481104 -> 1512096 bytes
 iwlwifi-9260-th-b0-jf-b0-46.ucode | Bin 1470272 -> 1483116 bytes
 iwlwifi-Qu-b0-hr-b0-59.ucode      | Bin 0 -> 1300764 bytes
 iwlwifi-Qu-b0-jf-b0-59.ucode      | Bin 0 -> 1226208 bytes
 iwlwifi-Qu-c0-hr-b0-59.ucode      | Bin 0 -> 1300780 bytes
 iwlwifi-Qu-c0-jf-b0-59.ucode      | Bin 0 -> 1226224 bytes
 iwlwifi-QuZ-a0-hr-b0-59.ucode     | Bin 0 -> 1299660 bytes
 iwlwifi-QuZ-a0-jf-b0-59.ucode     | Bin 0 -> 1226064 bytes
 iwlwifi-cc-a0-59.ucode            | Bin 0 -> 1261280 bytes
 iwlwifi-ty-a0-gf-a0-59.ucode      | Bin 0 -> 1413868 bytes
 15 files changed, 30 insertions(+), 6 deletions(-)
 create mode 100644 iwlwifi-Qu-b0-hr-b0-59.ucode
 create mode 100644 iwlwifi-Qu-b0-jf-b0-59.ucode
 create mode 100644 iwlwifi-Qu-c0-hr-b0-59.ucode
 create mode 100644 iwlwifi-Qu-c0-jf-b0-59.ucode
 create mode 100644 iwlwifi-QuZ-a0-hr-b0-59.ucode
 create mode 100644 iwlwifi-QuZ-a0-jf-b0-59.ucode
 create mode 100644 iwlwifi-cc-a0-59.ucode
 create mode 100644 iwlwifi-ty-a0-gf-a0-59.ucode

--=-JzpqeD+PbrpMeQiIQXgO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAl+G+6kACgkQoUecoho8
xfq1Zw/+KhY4lmrWwoUKZglUvF1fKUntVn5SstQ0gRhcX22UhmEYh92VnPoBMC8V
3PIva0cJMabE9qrOWulScFXR7hL4KmO6PrenLLDENYQcujJMHxND+95xwXRFxUbg
eHLWxJDoDTSQv5yk26av9A6Mqxq/EFmWQ/e4X7eGFGiAybv2YQZc07C/Dhbfelt9
jlt8PIuKj6N6/hcY3NwZbN0E/3DPMAaz8suGLiKK0KyPctVWPK4IYsOOQUi0gOlH
T/+y+U62mkEcAdDrsFqE5dOYFVHDVgrNo6m2l4dONqNXQVF6WVgwu+ctg+OjAA/S
dexN1IAdrki18VGhUoJxjTJA/O2RBRfWjo1wv42wxu6TqpfgI1MphX7ehJ0SgczS
3ApKVKgfT9z+nXWJecne/7ab3x67+ihef4n/I826NqiDeyv6I5HOz5bakQC21Bhq
sCt2RsVFFTmfl5u8JM4lkCWTJXd0oXSZM0qb8RvWBtmCIveQxvVgHUNKkBabdgY9
ziU1/DmkNrg47lDNz/tg12z44q856voE56Wz9z+HY1ww0PFVJIuaSZkoKsBb9WXA
WN7CAHiCTuFZuUEAAcEMwlbKbJzihxZBZ6cKQbYcAe2+IeMSPQusn9HnlZcjyRXG
zCN1zbHkqmI//Kuk0gSbP8okfX1/3HZLo1wQNvUaU0zygxYiqwQ=
=5Sx1
-----END PGP SIGNATURE-----

--=-JzpqeD+PbrpMeQiIQXgO--

