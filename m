Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:28334 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdL0KDk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Dec 2017 05:03:40 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [next] ath10k: wmi: remove redundant integer fc
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20171218150245.9073-1-colin.king@canonical.com>
References: <20171218150245.9073-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Message-ID: <9a6c9d36025e46fd9b22e985d3662d93@euamsexm01a.eu.qualcomm.com> (sfid-20171227_110418_875367_95637A28)
Date: Wed, 27 Dec 2017 11:03:31 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> Variable fc is being assigned but never used, so remove it. Cleans
> up the clang warning:
> 
> warning: Value stored to 'fc' is never read
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

a0709dfd7ff8 ath10k: wmi: remove redundant integer fc

-- 
https://patchwork.kernel.org/patch/10119831/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
