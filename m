Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:55989 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415Ab1IWLoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:44:05 -0400
Received: by mail-bw0-f51.google.com with SMTP id zu17so4583437bkb.24
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:44:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] wl12xx: remove TIM ie from probe response
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316077625-20014-1-git-send-email-eliad@wizery.com>
References: <1316077625-20014-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:43:59 +0300
Message-ID: <1316778239.2157.731.camel@cumari> (sfid-20110923_134409_122579_9342B31C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 12:07 +0300, Eliad Peller wrote: 
> wl12xx uses the beacon as the probe response template.
> However, the beacon includes a TIM ie, which shouldn't
> exist in the probe response.
> 
> Delete it from the skb before configuring the probe
> response template.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied both patches.  Thanks!

-- 
Cheers,
Luca.

