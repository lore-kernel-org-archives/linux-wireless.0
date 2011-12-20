Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:51448 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751694Ab1LTUu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:50:28 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id j5so2761716lag.15
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 12:50:26 -0800 (PST)
Subject: Re: [PATCH 0/7] wl12xx: various (multi-vif) fixes
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1324232745-22928-1-git-send-email-eliad@wizery.com>
References: <1324232745-22928-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 22:50:22 +0200
Message-ID: <1324414222.2182.73.camel@cumari> (sfid-20111220_215031_107176_5BB787FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-12-18 at 20:25 +0200, Eliad Peller wrote: 
> Fix some bugs related to multiple vifs support.
> 
> Eliad Peller (7):
>   wl12xx: implement change_interface
>   wl12xx: remove redundant code from wl1271_op_conf_tx
>   wl12xx: make WL1271_FLAG_IDLE flag per-vif
>   wl12xx: flush packets before stopping dev role
>   wl12xx: fix checking of started dev role
>   wl12xx: stop device role on remove_interface
>   wl12xx: check the actual vif operstate in wl1271_dev_notify
> 
>  drivers/net/wireless/wl12xx/cmd.c    |    3 +
>  drivers/net/wireless/wl12xx/main.c   |  100 +++++++++++++++++-----------------
>  drivers/net/wireless/wl12xx/ps.c     |   10 +++-
>  drivers/net/wireless/wl12xx/scan.c   |    2 +-
>  drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
>  5 files changed, 63 insertions(+), 54 deletions(-)

Applied, the series, with v2 of 1/7.  Thanks!

-- 
Cheers,
Luca.

