Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:59984 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1AXURc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:17:32 -0500
Subject: Re: [PATCH] wl12xx: Cleanup PLT mode when module is removed
From: Luciano Coelho <coelho@ti.com>
To: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295005726-10323-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1295005726-10323-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 22:17:40 +0200
Message-ID: <1295900260.2063.2.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-14 at 12:48 +0100, juuso.oikarinen@nokia.com wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> 
> PLT mode start/stop is controlled from userspace. When removing module, the
> PLT mode state is however not checked, and not cleared. There is the possibility
> of some unwanted state to left linger and there is even the possiblity of a
> kernel crash if for instance IRQ work is running when the module is removed.
> 
> Fix this by stopping PLT mode on module removal, if still running.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Applied.  Thanks, Juuso!

-- 
Cheers,
Luca.

