Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6FCC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 08:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E964A21473
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 08:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbfDCISj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 04:18:39 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49636 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725936AbfDCISi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 04:18:38 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBb6S-0007Xi-3n; Wed, 03 Apr 2019 11:18:36 +0300
Message-ID: <6f02ef035f948c9d01d66f52f84403caf2384001.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Wed, 03 Apr 2019 11:18:34 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-mpq+AXlktsrBYSnZZsuh"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Subject: pull-request: iwlwifi-fixes 2019-04-03
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-mpq+AXlktsrBYSnZZsuh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the second batch of fixes for v5.1.  More details about the
contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 4837696f6b5451242b2095764287b6336e844683=
:

  Merge tag 'iwlwifi-for-kalle-2019-03-22' of git://git.kernel.org/pub/scm/=
linux/kernel/git/iwlwifi/iwlwifi-fixes (2019-03-30 08:33:40 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2019-04-03

for you to fetch changes up to debec2f23910cb17f2c0f6d5e30a8da00bb5f515:

  iwlwifi: add support for quz firmwares (2019-04-03 11:13:06 +0300)

----------------------------------------------------------------
Second batch of iwlwifi fixes intended for v5.1

* fix for a potential deadlock in the TX path;
* a fix for offloaded rate-control;
* support new PCI HW IDs which use a new FW;

----------------------------------------------------------------
Johannes Berg (2):
      iwlwifi: mvm: avoid possible deadlock in TX path
      iwlwifi: mvm: update offloaded rate control on changes

Luca Coelho (1):
      iwlwifi: add support for quz firmwares

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c    | 18 ++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-config.h   |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  2 ++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c   |  4 ++++
 6 files changed, 31 insertions(+), 2 deletions(-)

--=-mpq+AXlktsrBYSnZZsuh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlykbFoACgkQoUecoho8
xfpb7A/+JEA6JQZzk3hpkB7SNaWtFpinXrntTUhNEi1/NsqP3LrngZtnpvVP5sng
BfouwjMkoN0cQXJxHSnZvwiw08vLiMpECxpWo0gPSXW7/IhrgfeaLVX9FjvwGz4v
zEYrvfxBdtYKhIQ50c2LgeO2F+esH5rB+DDQQXJMct/Vq8adqAth/PFSDxogx4fF
um6+8bo9jU/I/wzfT6bYo5+fCYe/UuUFy2weF3NVLy4ZTlUufzVgZLdBAHuHnLw4
LhMRT778SziqEpwMoUwMNA9el/XSilnCSU9UTNmZQaFnI8AANf4wTm9W6PUyx8cq
V0uyJsKNyWs3d6h1WOpQJOzASNQJhXz0DkRyeUB02nHgU7zrPtabB1DGoii6bukF
SeIi3u+ZB+F0bmoGCfwqusO5Yjvxa3WgLLFXSqswIorNwc4s83OlzOBsTAqAwwSC
mPBhQn0ApJoJkx5+ubwu8EXvD1ql3Vi6aaWJAiF3gmnDbgt4LD3AOTbVrj3sedu6
N2C64kgVG9yv8Znj/Wtro0R3o9aoM68F5v7nH7FdQ0whTdUQw2rTthqyxxOoZSmJ
BhV+nk1tzSS/OnVoRY1FvE0YOpzXMHVbVpxxUdDHybVbKMlczzDREzCzq4XtEsdH
uhfgAmbNUPGBRrsSFyJ1LTiFyNMWOsUtmtIghcviGBudUaPjVwM=
=NPx+
-----END PGP SIGNATURE-----

--=-mpq+AXlktsrBYSnZZsuh--

