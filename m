Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:48361 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab1D2ULS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:11:18 -0400
Received: by mail-ew0-f44.google.com with SMTP id 19so1405227ewy.3
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:11:17 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Modify memory configuration for 128x/AP
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303134014-31393-1-git-send-email-ido@wizery.com>
References: <1303134014-31393-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 23:05:01 +0300
Message-ID: <1304107501.12586.159.camel@cumari> (sfid-20110429_221124_058498_ABB32F0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-04-18 at 16:40 +0300, Ido Yariv wrote:
> The 128x/AP firmware does not yet support dynamic memory. Temporarily,
> the memory configuration for the 127x was used both for 127x/AP as well
> as 128x/AP. Since the two chips don't have the same number of memory
> blocks, TP was significantly degraded.
> 
> This hasn't been fine tuned yet, but using the base 128x numbers
> (without dynamic memory) seems to yield much better results (around 30%
> more). Additional fine tuning will be required in the future.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> --- 

Applied.

-- 
Cheers,
Luca.

