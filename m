Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49969 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752946AbdDEIG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:06:28 -0400
Date: Wed, 5 Apr 2017 10:06:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v3 1/5] NFC: pn544: Get rid of platform data
Message-ID: <20170405080618.GA2136@zurbaran.ger.intel.com> (sfid-20170405_100708_567369_1B7DED6F)
References: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170328093639.53481-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Tue, Mar 28, 2017 at 12:36:35PM +0300, Andy Shevchenko wrote:
> Legacy platform data must go away. We are on the safe side here since
> there are no users of it in the kernel.
> 
> If anyone by any odd reason needs it the GPIO lookup tables and
> built-in device properties at your service.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  v3: no change
> 
>  drivers/nfc/pn544/i2c.c             | 43 ++++++-------------------------------
>  include/linux/platform_data/pn544.h | 43 -------------------------------------
>  2 files changed, 6 insertions(+), 80 deletions(-)
>  delete mode 100644 include/linux/platform_data/pn544.h
All 5 patches applied to nfc-next.

Cheers,
Samuel.
