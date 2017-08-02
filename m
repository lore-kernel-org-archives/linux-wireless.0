Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12702 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752544AbdHBPTj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 11:19:39 -0400
Message-ID: <1501687174.29303.357.camel@linux.intel.com> (sfid-20170802_171942_462003_7CE675C8)
Subject: Re: [PATCH v1] ath10k: Switch to use new generic UUID API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Date: Wed, 02 Aug 2017 18:19:34 +0300
In-Reply-To: <87d18erpuv.fsf@kamboji.qca.qualcomm.com>
References: <20170802135725.9317-1-andriy.shevchenko@linux.intel.com>
         <87d18erpuv.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-08-02 at 14:44 +0000, Kalle Valo wrote:
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> writes:
> 
> > There are new types and helpers that are supposed to be used in new
> > code.
> > 
> > As a preparation to get rid of legacy types and API functions do
> > the conversion here.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> To which tree are you planning to submit this? Can I take this to my
> ath.git tree?

I guess it's precisely for your tree.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
