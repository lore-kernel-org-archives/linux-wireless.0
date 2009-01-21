Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38962 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbZAUTaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 14:30:46 -0500
Date: Wed, 21 Jan 2009 14:23:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] iwl3945: Remove unused variables
Message-ID: <20090121192329.GB14710@tuxdriver.com> (sfid-20090121_203051_048345_862D0A3F)
References: <200901190955.32818.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200901190955.32818.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 19, 2009 at 09:55:32AM +0100, Helmut Schaa wrote:
> Fix the following warnings in iwl-3945-rs.c by removing unused variab=
les.
>=20
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_rate_scale_flush_windows=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:186: warning: unused varia=
ble =E2=80=98priv=E2=80=99
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_bg_rate_scale_flush=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:219: warning: unused varia=
ble =E2=80=98priv=E2=80=99
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_collect_tx_data=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: warning: unused varia=
ble =E2=80=98priv=E2=80=99
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98rs_f=
ree_sta=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: warning: unused varia=
ble =E2=80=98priv=E2=80=99
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl3=
945_get_adjacent_rate=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945-rs.c:559: warning: unused varia=
ble =E2=80=98priv=E2=80=99
>=20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

With this applied, I get these:

  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-rs.o
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_rate_scale_flush_windows=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: (Each undeclared=
 identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:199: error: for each functio=
n it appears in.)
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_bg_rate_scale_flush=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:222: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_collect_tx_data=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:293: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98rs_fre=
e_sta=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:441: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-3945-rs.c: In function =E2=80=98iwl394=
5_get_adjacent_rate=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-3945-rs.c:594: error: =E2=80=98priv=E2=
=80=99 undeclared (first use in this function)
make[2]: *** [drivers/net/wireless/iwlwifi/iwl-3945-rs.o] Error 1
make[1]: *** [drivers/net/wireless/iwlwifi] Error 2
make: *** [drivers/net/wireless/] Error 2

Dropping...

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
