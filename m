Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53487 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758511AbdEWPZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 11:25:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: remove unnecessary code
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170509125129.GA21962@embeddedgus>
References: <20170509125129.GA21962@embeddedgus>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
CC: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Message-ID: <b5d346a9f0fd483f96b7f0fff6174750@euamsexm01a.eu.qualcomm.com> (sfid-20170523_172709_335873_5B684CA4)
Date: Tue, 23 May 2017 17:25:41 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:
> The array fields in struct wmi_start_scan_arg that are checked here are
> fixed size arrays so they can never be NULL.
> 
> Addresses-Coverity-ID: 1260031
> Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>

Patch applied to ath-next branch of ath.git, thanks.

8c1f20815231 ath10k: remove unnecessary code

-- 
https://patchwork.kernel.org/patch/9717869/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
