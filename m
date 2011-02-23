Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:42509 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536Ab1BWNv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:51:28 -0500
Received: by mail-ww0-f52.google.com with SMTP id 20so8172366wwd.9
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 05:51:25 -0800 (PST)
Subject: Re: [PATCH] wl12xx: update PLT initialization for new firmware
From: Luciano Coelho <coelho@ti.com>
To: Gery Kahn <gery.kahn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296550988-24974-1-git-send-email-geryk@ti.com>
References: <1296550988-24974-1-git-send-email-geryk@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:51:22 +0200
Message-ID: <1298469082.2104.19.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-01 at 03:03 -0600, Gery Kahn wrote:
> In revision > 6.1.3.0.0 the firmware expects memory configuration
> command
> as part of boot. This was missing if driver boots in PLT mode.
> The patch adds the memory configuration command, which fixes PLT
> commands
> tx continuous and rx statistics.
> 
> Signed-off-by: Gery Kahn <geryk@ti.com>
> --- 

Applied, thanks!

-- 
Cheers,
Luca.

