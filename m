Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:40394 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab1ISFLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 01:11:41 -0400
Received: by fxh13 with SMTP id 13so4967152fxh.32
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 22:11:39 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: add dynamic_ps_timeout debugfs entry
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316347759-22030-1-git-send-email-eliad@wizery.com>
References: <1316347759-22030-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 08:11:37 +0300
Message-ID: <1316409097.2157.11.camel@cumari> (sfid-20110919_071144_015128_0E16C231)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-18 at 15:09 +0300, Eliad Peller wrote: 
> Add debugfs entry to control the dynamic ps default
> timeout (value in ms).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Another thing, how are you planning to use this debugfs entry? Just for
testing, right? And if yes, I think it shouldn't, in the end, be a
debugfs entry, but something that the driver figures out by itself.  We
really cannot have non-debugging values settable in debugfs.

-- 
Cheers,
Luca.

