Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:34728 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781Ab2ALITw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 03:19:52 -0500
Received: by lago2 with SMTP id o2so939938lag.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 00:19:49 -0800 (PST)
Subject: Re: [PATCH] wl12xx: enable sparse endianess check by default
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1324497151-21295-1-git-send-email-coelho@ti.com>
References: <1324497151-21295-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 10:19:46 +0200
Message-ID: <1326356386.32758.17.camel@cumari> (sfid-20120112_091955_543642_F483839A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-21 at 21:52 +0200, Luciano Coelho wrote: 
> Following the good example of the Intel (and more recently Atheros)
> drivers, enable endianess check by default when running sparse.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied this series.


-- 
Cheers,
Luca.

