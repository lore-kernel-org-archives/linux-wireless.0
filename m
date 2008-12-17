Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48188 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYLQSpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 13:45:11 -0500
Date: Wed, 17 Dec 2008 11:39:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Rami Rosen <ramirose@gmail.com>
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
Subject: Re: [PATCH] [v2] iwlwifi: iwl-tx.c cleanup (remove unused
	parameters).
Message-ID: <20081217163908.GD12679@tuxdriver.com> (sfid-20081217_194518_991070_139F6E76)
References: <eb3ff54b0812152335p6f768aa4r7ad68b33e62bd20b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <eb3ff54b0812152335p6f768aa4r7ad68b33e62bd20b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 16, 2008 at 09:35:23AM +0200, Rami Rosen wrote:
> This patch removes unused parameters in methods in iwl-tx.c:
>=20
> - remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
> - remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
> - remove two parameters (sta_id and priv) from iwl_tx_cmd_build_hwcry=
pto()

  CC [M]  drivers/net/wireless/iwlwifi/iwl-tx.o
drivers/net/wireless/iwlwifi/iwl-tx.c: In function =E2=80=98iwl_tx_cmd_=
build_hwcrypto=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-tx.c:780: error: =E2=80=98priv=E2=80=99=
 undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-tx.c:780: error: (Each undeclared iden=
tifier is reported only once
drivers/net/wireless/iwlwifi/iwl-tx.c:780: error: for each function it =
appears in.)
make[2]: *** [drivers/net/wireless/iwlwifi/iwl-tx.o] Error 1

Did you compile w/ debugging enabled?

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
