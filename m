Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:38529 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760246AbXLRDEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 22:04:25 -0500
Message-ID: <476738B7.7030104@garzik.org> (sfid-20071218_030438_169394_FA64C3E0)
Date: Mon, 17 Dec 2007 22:04:23 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: iwlwifi: fix-up merge fall-out after namespace separation
References: <20071216043419.GF3096@tuxdriver.com> <47670514.4030204@garzik.org> <476708EF.10403@garzik.org> <20071218022540.GB3640@tuxdriver.com>
In-Reply-To: <20071218022540.GB3640@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
>> drivers/net/wireless/iwlwifi/iwl3945-base.c: In function=20
>> =E2=80=98iwl3945_alive_start=E2=80=99:
>> drivers/net/wireless/iwlwifi/iwl3945-base.c:6285: error: implicit=20
>> declaration of function =E2=80=98iwl_rate_control_unregister=E2=80=99
>> make[4]: *** [drivers/net/wireless/iwlwifi/iwl3945-base.o] Error 1
>> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

applied, thanks


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
