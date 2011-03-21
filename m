Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45040 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751492Ab1CUPn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 11:43:56 -0400
Received: by mail-ww0-f54.google.com with SMTP id 20so8425382wwd.35
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 08:43:54 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Add mutex protection for interface list
From: Luciano Coelho <coelho@ti.com>
To: juuso.oikarinen@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1300697016-1652-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1300697016-1652-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 17:43:16 +0200
Message-ID: <1300722196.2593.239.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 10:43 +0200, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> The interface list maintained in main.c is not mutex protected. This could
> cause issues, as the list is accessed from notifier chains.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Reviewed-by: Luciano Coelho <coelho@ti.com>

...and applied.  Thanks!

-- 
Cheers,
Luca.

