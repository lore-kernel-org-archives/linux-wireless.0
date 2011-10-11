Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:33347 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab1JKNWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 09:22:25 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so12231105bkb.33
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 06:22:24 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: sdio: use dev_dbg instead of wl1271_debug
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1317987297-18172-1-git-send-email-coelho@ti.com>
References: <1317987297-18172-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 16:22:15 +0300
Message-ID: <1318339335.9690.525.camel@cumari> (sfid-20111011_152228_748449_170846B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 14:34 +0300, Luciano Coelho wrote: 
> To prevent a useless dependency between the sdio module and the wl12xx
> module, we need to replace the wl1271_debug macros (and friends) for
> dev_dbg and other equivalents.
> 
> At the same time, remove the SDIO data hexdump, since this produces
> way too much data and is not particularly useful.  There's not
> print_hex_dump() equivalent for dynamic debug, so it's hard to control
> when the dumps are printed out.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied both.

-- 
Cheers,
Luca.

