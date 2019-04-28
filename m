Return-Path: <SRS0=6X5c=S6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A26DC43219
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 07:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40343206E0
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Apr 2019 07:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfD1HGx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Apr 2019 03:06:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:51122 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726133AbfD1HGx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Apr 2019 03:06:53 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hKdtj-0003va-Mn; Sun, 28 Apr 2019 10:06:51 +0300
Message-ID: <aab3d1cab0caf00d7c3ae1cc10ca3ec99cc54efd.camel@coelho.fi>
Subject: pull-request: iwlwifi-fixes 2019-04-28
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date:   Sun, 28 Apr 2019 10:06:50 +0300
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Rr2OitKfZfwwDi98LQVu"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--=-Rr2OitKfZfwwDi98LQVu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

This is the fourth batch of fixes for v5.1.  It contains two fixes I
send in the last patchset plus a patch that I sent separately to fix a
merge damage caused by the previous pull.  More details about the
contents in the tag description.

I have sent this out before and kbuildbot reported success.

Please let me know if there are any issues.

Cheers,
Luca.


The following changes since commit b82d6c1f8f8288f744a9dcc16cd3085d535decca=
:

  mwifiex: Make resume actually do something useful again on SDIO cards (20=
19-04-25 14:05:14 +0300)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2019-04-28

for you to fetch changes up to d156e67d3f58c5d3c7ebe1bec80657db534f32d4:

  iwlwifi: mvm: fix merge damage in iwl_mvm_vif_dbgfs_register() (2019-04-2=
8 09:59:59 +0300)

----------------------------------------------------------------
Fourth batch of patches intended for v5.1

* Fix an oops when we receive a packet with bogus lengths;
* Fix a bug that prevented 5350 devices from working;
* Fix a small merge damage from the previous series;

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: fix driver operation for 5350

Luca Coelho (2):
      iwlwifi: mvm: check for length correctness in iwl_mvm_create_skb()
      iwlwifi: mvm: fix merge damage in iwl_mvm_vif_dbgfs_register()

 drivers/net/wireless/intel/iwlwifi/cfg/5000.c        |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |  6 ------
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c        | 28 ++++++++++++++++=
++++++++----
 3 files changed, 26 insertions(+), 11 deletions(-)

--=-Rr2OitKfZfwwDi98LQVu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF3LNfgb2BPWm68smoUecoho8xfoFAlzFUQoACgkQoUecoho8
xfoF9w//QIItObPeaFAFkhrIP0hke2y/T9gL35M6AN9rcnqrMy47JGBTetSpAWNv
gkK0RJC4tqz+dSrziVyjBy69NsjVtMLJu28EGeTC5iNkdEpQNQ/cGQxPBYZohK4M
o4v8ruHFYdQcI6w+UMGFOsD9/rWIeANePJlStZlpp15vZ/bKDDmGGDmlWyM3AZ6W
85kWRSt+Aj3B0B/JChXls6BUaBMpbi33F2RvdkwCh1BlQ5MajqBhl1B+26Fr+trF
naygE338YBiuOozHFCBKBKC+/7+pYi0CBDCSY/7ZkL2l11rNpunvUg+6QAebts2P
hZ/0t4wFnoI6qJXHQhRJd+mSXm5DLScCQFS5rSQIksmbEF5t/p+twd7qQoNi+VJF
qSjs9HI5AQ0SfF0wohENmCNdq6TMRxJJCACVocflbTbFgkosAbIpb3CDEg4LurcE
7iPuYPv0bAMHevcmWItm+W4aL/YeaDACLoM4Py5LVwSj/dlZ/+q0vXY5xdbIsCkh
DQSUoYQnUjBrTHCHrwHDSKJfh29AmEUk5zoWxxR4VcCyRZZB/xnCFiN/ksvyWe9b
mMVLtgxm/SBkMpSE+TfmvyiFFxAlkzavTSc/q45/p5JqoOasf+uETXqxYTcoLESC
ZdJu2IptJsjjoY++OakFXmq8IlhZahlcpwhlihmi2EkgocywaDk=
=UMGQ
-----END PGP SIGNATURE-----

--=-Rr2OitKfZfwwDi98LQVu--

