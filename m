Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41839 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1AXVPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:15:20 -0500
Subject: Re: [PATCH] wl12xx: wrong values are returned in gpio_power_write()
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295778327-20545-1-git-send-email-eliad@wizery.com>
References: <1295778327-20545-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 23:15:29 +0200
Message-ID: <1295903729.4430.2.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-23 at 11:25 +0100, Eliad Peller wrote:
> Return values were assigned to incorrect var / weren't assigned.
> fix it, and defer mutex_lock after the sanity checks.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Looks good.  Applied, thanks!

-- 
Cheers,
Luca.

