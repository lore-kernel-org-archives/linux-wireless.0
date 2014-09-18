Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64100 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaIRFp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 01:45:29 -0400
Message-ID: <541A7177.3010100@lwfinger.net> (sfid-20140918_074608_319352_3EBBAA66)
Date: Thu, 18 Sep 2014 00:45:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
CC: Masanari Iida <standby24x7@gmail.com>, netdev@vger.kernel.org,
	davem@davemloft.net
Subject: Re: [PATCH] [trivial] wireless:rtlwifi: Fix typo in rtl wifi drivers
References: <1411010992-9999-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1411010992-9999-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/2014 10:29 PM, Masanari Iida wrote:
> This patch fix spelling typo "sleeped" in printk, found in
> multiple rtlwifi drivers.
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8188ee/phy.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192ce/phy.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192cu/phy.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192de/phy.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8192se/phy.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8723ae/phy.c | 2 +-
>   drivers/net/wireless/rtlwifi/rtl8723be/phy.c | 2 +-
>   7 files changed, 7 insertions(+), 7 deletions(-)

John,

Please do not apply this patch for two reasons. (1) It would interfere with the 
major changes that I will be sending in the next few days. (2) I have been 
favoring "sleeping" over "slept" as a substitute for "sleeped". If I change my 
mind, I will resubmit this patch with Masanari as the author.

Thanks,

Larry

