Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:40390 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034Ab2BOKSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:18:50 -0500
Received: by mail-lpp01m010-f43.google.com with SMTP id p5so1018068lag.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:18:46 -0800 (PST)
Message-ID: <1329301121.19569.43.camel@cumari> (sfid-20120215_111853_882834_CB1BC5A3)
Subject: Re: [PATCH 0/3] wl12xx: re-enable auto-arp
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:18:41 +0200
In-Reply-To: <1328178131-28938-1-git-send-email-eliad@wizery.com>
References: <1328178131-28938-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-02 at 12:22 +0200, Eliad Peller wrote: 
> auto-arp used to cause various issues when enabled. however,
> after some fixes both in the driver and fw side, it seems to
> work well. re-enable it.
> 
> Eliad Peller (3):
>   wl12xx: consider encryption and QoS in auto arp template
>   wl12xx: Revert "wl12xx: disable auto-arp"
>   wl12xx: configure arp filtering only after association

Applied this set, thanks.

-- 
Cheers,
Luca.

