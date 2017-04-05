Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6109 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754144AbdDEIJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:09:27 -0400
Date: Wed, 5 Apr 2017 10:09:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Subject: Re: [PATCH v2 1/5] NFC: st21nfca: Fix obvious typo when check error
 code
Message-ID: <20170405080918.GB2136@zurbaran.ger.intel.com> (sfid-20170405_101039_782172_74F2BFAF)
References: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307102546.32224-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Tue, Mar 07, 2017 at 12:25:42PM +0200, Andy Shevchenko wrote:
> We return -ENODEV if ACPI provides a GPIO resource. Looks really wrong.
> If it has even been tested?
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
All 5 patches applied to nfc-next, thanks.

Cheers,
Samuel.
