Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44015 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854AbXLQXkd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 18:40:33 -0500
Message-ID: <476708EF.10403@garzik.org> (sfid-20071217_234039_117782_0924CB55)
Date: Mon, 17 Dec 2007 18:40:31 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Please pull 'upstream-jgarzik' branch of wireless-2.6
References: <20071216043419.GF3096@tuxdriver.com> <47670514.4030204@garzik.org>
In-Reply-To: <47670514.4030204@garzik.org>
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hum, this required merging also, and broke the build too :/

drivers/net/wireless/iwlwifi/iwl3945-base.c: In function=20
=91iwl3945_alive_start=92:
drivers/net/wireless/iwlwifi/iwl3945-base.c:6285: error: implicit=20
declaration of function =91iwl_rate_control_unregister=92
make[4]: *** [drivers/net/wireless/iwlwifi/iwl3945-base.o] Error 1
make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

I'll leave it there and assume that you will send a fix --on top of--=20
netdev#upstream ...



-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
