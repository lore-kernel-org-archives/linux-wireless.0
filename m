Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33848 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbdH3QhJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 12:37:09 -0400
Subject: Re: [PATCH] rtlwifi: btcoex: 23b 1ant: fix duplicated code for
 different branches
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Pkshih <pkshih@realtek.com>, Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20170830134223.GA13596@embeddedgus>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <eef42b52-ae7b-e574-237f-209ac8ec033c@lwfinger.net> (sfid-20170830_183739_068066_6D317FF7)
Date: Wed, 30 Aug 2017 11:37:06 -0500
MIME-Version: 1.0
In-Reply-To: <20170830134223.GA13596@embeddedgus>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2017 08:42 AM, Gustavo A. R. Silva wrote:
> Refactor code in order to avoid identical code for different branches.
> 
> This issue was detected with the help of Coccinelle.
> 
> Addresses-Coverity-ID: 1226788
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> This issue was reported by Coverity and it was tested by compilation only.
> I'm suspicious this may be a copy/paste error. Please, verify.

I have referred this change to the engineers at Realtek. For the moment, please 
hold this patch.

Thanks for reporting the condition.

Larry
