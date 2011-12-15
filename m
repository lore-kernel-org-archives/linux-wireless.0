Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:42902 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990Ab1LOIxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:53:55 -0500
Received: by lags15 with SMTP id s15so1178861lag.18
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 00:53:52 -0800 (PST)
Subject: Re: [PATCH] wl12xx: call extended radio parameters for wl127x AP
 mode
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1323769190-20559-1-git-send-email-coelho@ti.com>
References: <1323769190-20559-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 10:53:48 +0200
Message-ID: <1323939228.2800.179.camel@cumari> (sfid-20111215_095357_366289_D436E6D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-13 at 11:39 +0200, Luciano Coelho wrote: 
> We need to set the extended radio parameters for wl127x only.
> Currently, we were only calling this command with wl127x STA mode, but
> we should also do it for AP mode.
> 
> Move the call to the extended radio paramaters to the common hw_init
> and use a single if for the chip type to do everything at once.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

