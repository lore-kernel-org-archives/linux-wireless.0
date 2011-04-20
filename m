Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:55282 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937Ab1DTSFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 14:05:14 -0400
Received: by eyh5 with SMTP id 5so345378eyh.40
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 11:05:12 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: configure rates when working in ibss mode
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1302180725-8796-1-git-send-email-eliad@wizery.com>
References: <1302180725-8796-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 21:07:40 +0300
Message-ID: <1303322860.1988.741.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-07 at 15:52 +0300, Eliad Peller wrote:
> When working in ibss mode, we don't configure rate policy per station
> (as we use the same link for multiple stations), so currently the
> 1mb/s rate is being used.
> 
> Instead, configure the firmware to use the whole 11b rates by default.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, obrigado! ;)

-- 
Cheers,
Luca.

