Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:51865 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751590Ab2FHNco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 09:32:44 -0400
Received: by lagz14 with SMTP id z14so1711714lag.21
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 06:32:32 -0700 (PDT)
Message-ID: <1339162351.7078.145.camel@cumari.coelho.fi> (sfid-20120608_153246_748030_2BA10AA5)
Subject: Re: [PATCH 0/5] wl18xx: some alignment with new FWs and conf
 improvements
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Date: Fri, 08 Jun 2012 16:32:31 +0300
In-Reply-To: <1339137055-30095-1-git-send-email-coelho@ti.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 09:30 +0300, Luciano Coelho wrote:
> Hi,
> 
> Here are a few more patches for wl18xx (or directly related to it).
> Two of them align features and the ABI of newer firmware versions: the
> new statistics structure format by Ido and the support for FW logger
> by default with PG2.0 chips by Arik.
> 
> Then there are three more patches by Arik that improve the conf binary
> handling.  Align the entire phy structure with the one used by the
> firmware, fix the module parameters to reflect the new placement of
> the settings (which are now in the conf structure) and make the NVS
> file optional, in preparation for total removal from wl18xx.
> 
> Thanks guys for these patches!
> 
> Cheers,
> Luca.
> 
> Arik Nemtsov (4):
>   wl18xx: allow FW-log by default for PG2.0
>   wl18xx: align wl18xx_conf_phy with FW variant and remove it
>   wl18xx: clean up phy module parameters
>   wlcore/wl12xx/wl18xx: make NVS file optional for wl18xx
> 
> Ido Reis (1):
>   wl18xx: update fw statistics
> 
>  drivers/net/wireless/ti/wl18xx/acx.h     |   33 ++++--
>  drivers/net/wireless/ti/wl18xx/conf.h    |   37 ++++++-
>  drivers/net/wireless/ti/wl18xx/debugfs.c |   56 ++++++----
>  drivers/net/wireless/ti/wl18xx/main.c    |  165 +++++++++++-------------------
>  drivers/net/wireless/ti/wl18xx/reg.h     |   57 -----------
>  drivers/net/wireless/ti/wl18xx/wl18xx.h  |    2 -
>  drivers/net/wireless/ti/wlcore/boot.c    |    4 +-
>  drivers/net/wireless/ti/wlcore/main.c    |   22 ++--
>  8 files changed, 166 insertions(+), 210 deletions(-)

Applied and pushed!

--
Luca.

