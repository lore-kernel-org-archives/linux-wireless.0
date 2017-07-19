Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34091 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752021AbdGSBfm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Jul 2017 21:35:42 -0400
Subject: Re: [PATCH] rtlwifi: remove useless code
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170718204106.GA9905@embeddedgus>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e30fe757-52cd-ce07-afc6-f9070de9923d@lwfinger.net> (sfid-20170719_033604_898735_96B26B8E)
Date: Tue, 18 Jul 2017 20:35:39 -0500
MIME-Version: 1.0
In-Reply-To: <20170718204106.GA9905@embeddedgus>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/18/2017 03:41 PM, Gustavo A. R. Silva wrote:
> Remove useless local variables last_read_point and last_txw_point and
> the code related.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 6 ------
>   1 file changed, 6 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry
