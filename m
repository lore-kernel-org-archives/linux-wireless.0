Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:43760 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752992AbdFRXLq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Jun 2017 19:11:46 -0400
Date: Mon, 19 Jun 2017 01:11:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, Linux NFC <linux-nfc@lists.01.org>
Subject: Re: [PATCH v2 00/12] NFC: clean up for ACPI GPIO usage
Message-ID: <20170618231142.GA3678@zurbaran.ger.intel.com> (sfid-20170619_011151_547122_EF73AF27)
References: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Mon, Jun 05, 2017 at 11:19:57PM +0300, Andy Shevchenko wrote:
> Andy Shevchenko (12):
>   NFC: pn544: Switch to devm_acpi_dev_add_driver_gpios()
>   NFC: st21nfca: Add GPIO ACPI mapping table
>   NFC: st21nfca: Get rid of code duplication in ->probe()
>   NFC: fdp: Convert I2C driver to ->probe_new()
>   NFC: fdp: Convert to use devres API
>   NFC: fdp: Add GPIO ACPI mapping table
>   NFC: st-nci: Get rid of platform data
>   NFC: st-nci: Get rid of "interesting" use of interrupt polarity
>   NFC: st-nci: Covert to use GPIO descriptor
>   NFC: st-nci: Use unified device property API meaningfully
>   NFC: st-nci: Add GPIO ACPI mapping table
>   NFC: st-nci: Get rid of code duplication in ->probe()
After fixing a couple of nitpicks, all patches applied now.
I'm fine with getting rid of the platform data, let's see if out of tree
users (especially for the ST driver) complain. Also, I'd appreciate if
you could cc linux-nfc to your submissions.

Cheers,
Samuel.
