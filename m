Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:41052 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751927AbdHHLIC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 07:08:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v1] ath10k: Switch to use new generic UUID API
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170802135725.9317-1-andriy.shevchenko@linux.intel.com>
References: <20170802135725.9317-1-andriy.shevchenko@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>
Message-ID: <8f7406eceeba4163a5ced29cb35f4244@euamsexm01a.eu.qualcomm.com> (sfid-20170808_130806_058848_DE555BC4)
Date: Tue, 8 Aug 2017 13:07:55 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> There are new types and helpers that are supposed to be used in new code.
> 
> As a preparation to get rid of legacy types and API functions do
> the conversion here.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

ab3f9c886865 ath10k: switch to use new generic UUID API

-- 
https://patchwork.kernel.org/patch/9876823/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
