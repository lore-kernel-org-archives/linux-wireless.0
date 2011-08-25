Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:55958 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab1HYHUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 03:20:08 -0400
Received: by mail-bw0-f54.google.com with SMTP id t8so2050659bka.13
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 00:20:07 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: allow 11a AP-mode for wl127x devices
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314104183-31612-1-git-send-email-eliad@wizery.com>
References: <1314104183-31612-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 10:20:03 +0300
Message-ID: <1314256803.2296.247.camel@cumari> (sfid-20110825_092012_498005_7C813442)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-23 at 15:56 +0300, Eliad Peller wrote: 
> From: Arik Nemtsov <arik@wizery.com>
> 
> There was a check preventing 127x devices from using the 11a band when
> operating as AP. Since we now support this functionality, remove the
> check.
> 
> With this patch, a 11a AP starts ok on 127x cards.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied both patches to wl12xx.git. Thanks.

-- 
Cheers,
Luca.

