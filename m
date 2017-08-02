Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56474 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbdHBOoq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 10:44:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v1] ath10k: Switch to use new generic UUID API
Date: Wed, 2 Aug 2017 14:44:41 +0000
Message-ID: <87d18erpuv.fsf@kamboji.qca.qualcomm.com> (sfid-20170802_164450_508344_766AA516)
References: <20170802135725.9317-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170802135725.9317-1-andriy.shevchenko@linux.intel.com> (Andy
        Shevchenko's message of "Wed, 2 Aug 2017 16:57:25 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:

> There are new types and helpers that are supposed to be used in new code.
>
> As a preparation to get rid of legacy types and API functions do
> the conversion here.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

To which tree are you planning to submit this? Can I take this to my
ath.git tree?

--=20
Kalle Valo=
