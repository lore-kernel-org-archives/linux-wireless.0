Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:35628 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758092Ab2FEOab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 10:30:31 -0400
Received: by lagw12 with SMTP id w12so4109721lag.24
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 07:30:28 -0700 (PDT)
Message-ID: <1338906626.13935.244.camel@cumari.coelho.fi> (sfid-20120605_163044_058471_48564E44)
Subject: Re: [PATCH 01/10] wlcore: fix sparse warnings related to static
 functions
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Jun 2012 17:30:26 +0300
In-Reply-To: <1337090940-13750-1-git-send-email-arik@wizery.com>
References: <1337090940-13750-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 17:08 +0300, Arik Nemtsov wrote:
> The "static" modifier was mistakenly forgotten for some functions.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> These patches apply on top of the wl18xx support series.

Applied and pushed to wl12xx/master.

-- 
Cheers,
Luca.

