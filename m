Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B37C64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 713E12089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 713E12089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbeJCOF0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:05:26 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54998 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726521AbeJCOFZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:05:25 -0400
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1g7bQF-0008Ca-DQ; Wed, 03 Oct 2018 10:18:16 +0300
Message-ID: <9ea7a802cbf547ca44b604e2b13bd6a1030bbb2b.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     linux-firmware@kernel.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        Josh Boyer <jwboyer@kernel.org>,
        Kyle McMartin <kyle@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        emmanuel.grumbach@intel.com
Date:   Wed, 03 Oct 2018 10:18:14 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-LJxqDtvZsFsYJtn05yxj"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Subject: pull-request: iwlwifi firmwares update 2018-10-03
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-LJxqDtvZsFsYJtn05yxj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

We have updated all the firmwares we currently support.

Please pull or let me know if there are any issues.

Cheers,
Luca.


The following changes since commit 7c81f23ad903f72e87e2102d8f52408305c0f7a2=
:

  ti-connectivity: add firmware for CC2560(A) Bluetooth (2018-10-01 10:08:3=
0 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git =
tags/iwlwifi-fw-2018-10-03

for you to fetch changes up to da110f2f392ab0f9a4e3cc35402b1f3e2c58127f:

  iwlwifi: add -41.ucode firmwares for 9000 series (2018-10-03 10:08:09 +03=
00)

----------------------------------------------------------------
iwlwifi: updata all currently supported FWs

* Update FWs for 3160, 7260 and 7265;
* Update FWs for 3168 and 7265D;
* Update FWs for 8000C and 8265;
* Update FWs for 9000 and 9260.

----------------------------------------------------------------
Emmanuel Grumbach (2):
      iwlwifi: update firmwares for 9000 series
      iwlwifi: add -41.ucode firmwares for 9000 series

Luca Coelho (1):
      iwlwifi: update firmwares for 7000, 8000 and 9000 series

 WHENCE                            |  20 +++++++++++++-------
 iwlwifi-3160-17.ucode             | Bin 918268 -> 918268 bytes
 iwlwifi-7260-17.ucode             | Bin 1049340 -> 1049340 bytes
 iwlwifi-7265-17.ucode             | Bin 1180412 -> 1180412 bytes
 iwlwifi-8000C-36.ucode            | Bin 2486572 -> 2486572 bytes
 iwlwifi-8265-36.ucode             | Bin 2498044 -> 2498044 bytes
 iwlwifi-9000-pu-b0-jf-b0-38.ucode | Bin 2520568 -> 2520568 bytes
 iwlwifi-9000-pu-b0-jf-b0-41.ucode | Bin 0 -> 2961864 bytes
 iwlwifi-9260-th-b0-jf-b0-38.ucode | Bin 2521412 -> 2521412 bytes
 iwlwifi-9260-th-b0-jf-b0-41.ucode | Bin 0 -> 2620368 bytes
 10 files changed, 13 insertions(+), 7 deletions(-)
 create mode 100644 iwlwifi-9000-pu-b0-jf-b0-41.ucode
 create mode 100644 iwlwifi-9260-th-b0-jf-b0-41.ucode

--=-LJxqDtvZsFsYJtn05yxj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlu0bTYACgkQoUecoho8
xfophA/9GovUPxQ52RNrHfIyA3S2zc9ExK+RgRpo+oQMSmFO9aS5zzV6wqAdSC/m
kOirGGvScap9WKm337Vmibjhzr3aCQz/ElsUqqDaXrn/P1vdKGSS/yw7reIQPgDv
2Q5N+dcGgiLmutc78noLjgwSEeFY745kIZg0NHPAuHzUjemnwmDoNN94t1sa8ekx
GFZ/SAdQEY7PIXSALB3Ddjw0jAghzAvXSUStwOXaxtSKa3NoPcM4IrVbNggzMcdL
JDU4dvhKY5C33zzuvYvitlmsastqM1y3zBwDVcaxAGowydu0t4h2zDwi3Fwb8HDr
OkJO6fSCIK2z3QNyMQhnPLrct5tJ9WiOlYTPMbwLd7hCQCD1jnHpPTpMG2aS822n
H0Hiz2mQAd1c+4Zvfzk80hnDqY7DTUSpaH1EtN90G7XRwHRbWmviU2LVgvScGYzD
w16wu5wYl4BavpNWazBerC79taXtTYFcpQG/EiE8kJIL6UletqZFKEGzZR53nIh6
1LLQ1wbPzbMLx68SvFjQSrEN0rQKzzbmuY809mJRfPlC01ugZuNUXTreHs72ZvmZ
sV11QiSPGiPEK78Cn+sfkQKanwtq2fO/MYsLhhz4OtyuwKAFRNjU3kaiEmSZentb
QS1gOLynCgR92hkzeRPKxDo2xFQBDeCNzgtbgbQJSx974qkIwO0=
=mY4l
-----END PGP SIGNATURE-----

--=-LJxqDtvZsFsYJtn05yxj--

