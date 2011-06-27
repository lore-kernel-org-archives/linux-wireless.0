Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:48111 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757646Ab1F0LHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 07:07:15 -0400
Received: by mail-bw0-f47.google.com with SMTP id 20so2017150bwf.34
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 04:07:13 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: check the vif's operstate after join
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1307354592-32685-1-git-send-email-eliad@wizery.com>
References: <1307354592-32685-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:07:10 +0300
Message-ID: <1309172830.30221.28.camel@cumari> (sfid-20110627_131517_401100_3D7F1D19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 13:03 +0300, Eliad Peller wrote: 
> When resuming while connected (without wowlan), the interface
> is already IF_OPER_UP, so we won't get the notifier callback,
> and hence never complete the association (from wl12xx perspective)
> 
> This situation, among other potential problems, prevents the
> station from entering psm.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thank you!

-- 
Cheers,
Luca.

