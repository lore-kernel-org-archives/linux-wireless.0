Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:46721 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987Ab1H3Fl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 01:41:29 -0400
Received: by mail-bw0-f48.google.com with SMTP id t2so8441219bka.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Aug 2011 22:41:27 -0700 (PDT)
Subject: Re: [PATCH] wl12xx/sdio_test.c: fix build breakage from
 WL127X_FW_NAME change
From: Luciano Coelho <coelho@ti.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314647622-23164-1-git-send-email-linville@tuxdriver.com>
References: <1314647622-23164-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Aug 2011 08:41:23 +0300
Message-ID: <1314682883.2296.402.camel@cumari> (sfid-20110830_074131_194103_88EC54C9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-29 at 15:53 -0400, John W. Linville wrote: 
> Commit c302b2c959164622558474871ae942da0e484a38 ("wl12xx: Use a single
> fw for both STA and AP roles") changed the name of the firmware name
> definition, breaking the build of wl12xx/sdio_test.c.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---

Thanks, John.  For some weird reason, WL12XX_SDIO_TEST sneaked away from
my kernel configuration and this slipped through.

-- 
Cheers,
Luca.

