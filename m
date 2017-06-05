Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:64560 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdFEUVC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:21:02 -0400
Message-ID: <1496694059.22624.26.camel@linux.intel.com> (sfid-20170605_222105_233186_AA8F6DA4)
Subject: Re: [PATCH v1 1/2] NFC: st21nfca: Add GPIO ACPI mapping table
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Christophe Ricard <christophe.ricard@gmail.com>
Date: Mon, 05 Jun 2017 23:20:59 +0300
In-Reply-To: <1495478015.6967.65.camel@linux.intel.com>
References: <20170424184128.48061-1-andriy.shevchenko@linux.intel.com>
         <1495478015.6967.65.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-05-22 at 21:33 +0300, Andy Shevchenko wrote:
> On Mon, 2017-04-24 at 21:41 +0300, Andy Shevchenko wrote:
> > In order to make GPIO ACPI library stricter prepare users of
> > gpiod_get_index() to correctly behave when there no mapping is
> > provided by firmware.
> > 
> > Here we add explicit mapping between _CRS GpioIo() resources and
> > their names used in the driver.
> > 
> 
> Samuel, can you apply this if no objections?

Never mind, I just sent v2 with other drivers fixed / cleaned up as
well.

Please, review, we already at rc4.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
