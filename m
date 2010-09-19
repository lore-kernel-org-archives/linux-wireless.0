Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:25934 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab0ISTqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Sep 2010 15:46:22 -0400
Subject: Re: [PATCH 1/2] wl1271: avoid redundant memcpy of rx_status
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1284915309-999-1-git-send-email-eliad@wizery.com>
References: <1284915309-999-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 22:46:12 +0300
Message-ID: <1284925572.10001.4.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-09-19 at 18:55 +0200, ext Eliad Peller wrote:
> copy the rx_status directly to skb->cb (control buffer) instead of copying
> it to a local struct and then copying it again (for each rx packet)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

Thanks, Eliad!


-- 
Cheers,
Luca.

