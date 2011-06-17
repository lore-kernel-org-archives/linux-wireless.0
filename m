Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45771 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab1FQP1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 11:27:22 -0400
Received: by vxi39 with SMTP id 39so2054918vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 08:27:21 -0700 (PDT)
Message-ID: <4DFB7256.8070307@lwfinger.net> (sfid-20110617_172725_540136_C2B9DC6D)
Date: Fri, 17 Jun 2011 10:27:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mike McCormack <mikem@ring3k.org>
CC: chaoming_li@realsil.com.cn, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] rtlwifi: rtl8192{c,ce,cu,se}: Remove comparisons
 of booleans with true
References: <4DF93EE1.1090102@ring3k.org>
In-Reply-To: <4DF93EE1.1090102@ring3k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/15/2011 06:23 PM, Mike McCormack wrote:
> These are a potential source of confusion, as most C code treats all
> non-zero values as true.
>
> Signed-off-by: Mike McCormack<mikem@ring3k.org>
> ---
>   drivers/net/wireless/rtlwifi/base.c               |    2 +-
>   drivers/net/wireless/rtlwifi/core.c               |    4 ++--
>   drivers/net/wireless/rtlwifi/efuse.c              |    8 ++++----
>   drivers/net/wireless/rtlwifi/ps.c                 |    2 +-
>   drivers/net/wireless/rtlwifi/rc.c                 |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192ce/hw.c       |   10 +++++-----
>   drivers/net/wireless/rtlwifi/rtl8192ce/led.c      |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192ce/rf.c       |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192ce/trx.c      |    6 +++---
>   drivers/net/wireless/rtlwifi/rtl8192cu/hw.c       |    8 ++++----
>   drivers/net/wireless/rtlwifi/rtl8192cu/led.c      |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192cu/rf.c       |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c      |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/dm.c       |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/hw.c       |    6 +++---
>   drivers/net/wireless/rtlwifi/rtl8192se/led.c      |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/phy.c      |    4 ++--
>   drivers/net/wireless/rtlwifi/rtl8192se/rf.c       |    2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/trx.c      |    6 +++---
>   20 files changed, 38 insertions(+), 38 deletions(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks for doing this.

Larry

