Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61115 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161326AbaJ3WqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 18:46:10 -0400
Message-ID: <5452BF4B.5070009@gmail.com> (sfid-20141030_234616_629535_DC78E125)
Date: Thu, 30 Oct 2014 20:44:27 -0200
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6 3.18] Fixes for iwlwifi drivers
References: <1414642633-3700-1-git-send-email-Larry.Finger@lwfinger.net>
In-Reply-To: <1414642633-3700-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2014 02:17 AM, Larry Finger wrote:
> Some late changes to rtlwifi made some of the older drivers not start correctly.
> These patches should be applied to 3.18.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
>
> Larry Finger (6):
>    rtlwifi: rtl8192ce: rtl8192de: rtl8192se: Fix handling for missing
>      get_btc_status
>    rtlwifi: rtl8192se: Fix duplicate calls to ieee80211_register_hw()
>    rtlwifi: rtl8192se: Add missing section to read descriptor setting
>    rtlwifi: rtl8192ce: Add missing section to read descriptor setting
>    rtlwifi: rtl8821ae: Remove extra semicolons
>    rtlwifi: rtl8192se: Fix firmware loading
>
>   drivers/net/wireless/rtlwifi/core.c          |  6 ++++++
>   drivers/net/wireless/rtlwifi/core.h          |  1 +
>   drivers/net/wireless/rtlwifi/rtl8192ce/def.h |  2 ++
>   drivers/net/wireless/rtlwifi/rtl8192ce/sw.c  |  1 +
>   drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  3 +++
>   drivers/net/wireless/rtlwifi/rtl8192de/sw.c  |  1 +
>   drivers/net/wireless/rtlwifi/rtl8192se/def.h |  2 ++
>   drivers/net/wireless/rtlwifi/rtl8192se/sw.c  | 22 +++-------------------
>   drivers/net/wireless/rtlwifi/rtl8192se/trx.c |  3 +++
>   drivers/net/wireless/rtlwifi/rtl8821ae/phy.c | 12 ++++++------
>   10 files changed, 28 insertions(+), 25 deletions(-)
>
Hi, Larry.

I've applied this patchset on top of next-20141030 and got the same 
result: kernel panic went away but the rtl8192se device does not associate.

Thanks anyway for dedicating your family time to trying to get this fixed.

We can talk about that later when you're back on regular schedule.

Appreciated!

-- 
Murilo
