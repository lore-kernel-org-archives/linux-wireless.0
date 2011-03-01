Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:37641 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754549Ab1CAOGZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 09:06:25 -0500
Received: by mail-wy0-f170.google.com with SMTP id 19so8349859wyf.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 06:06:23 -0800 (PST)
Subject: Re: [PATCH v2 2/7] wl12xx: Do end-of-transactions transfers only
 if needed
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <1298985284-6048-3-git-send-email-ido@wizery.com>
References: <1298985284-6048-1-git-send-email-ido@wizery.com>
	 <1298985284-6048-3-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 16:06:20 +0200
Message-ID: <1298988380.2104.239.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nice idea to have this quirks bitmask to isolate the
hw-revision-specific hacks!

On Tue, 2011-03-01 at 15:14 +0200, Ido Yariv wrote:
> +/* Quirks */
> +
> +/* Each RX/TX transaction requires an end-of-transaction transfer */
> +#define WL12XX_QUIRK_END_OF_TRANSACTION        BIT(1) 

Why not start with BIT(0)? ;)

-- 
Cheers,
Luca.

