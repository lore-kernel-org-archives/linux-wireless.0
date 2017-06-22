Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42424 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752741AbdFVVzL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:55:11 -0400
Date: Thu, 22 Jun 2017 23:55:07 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH v3 00/13] NFC: clean up for ACPI GPIO usage
Message-ID: <20170622215507.GA21214@zurbaran.ger.intel.com> (sfid-20170622_235514_509923_5C506A8C)
References: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170619100858.2655-1-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Mon, Jun 19, 2017 at 01:08:45PM +0300, Andy Shevchenko wrote:
> This clean up series to NFC drivers that are using GPIOs on ACPI enabled
> platforms. Since GPIO ACPI library goes stricter about requesting
> resources we need to amend drivers for that. Here we are for NFC
> subsystem.
> 
> While doing above, get rid of legacy and unused platform data as well as
> some artificial IDs.
> 
> Changelog v3:
> - incorporate Samuel's fixes
> - fix the bug kbuild bot complains about
> - add MAINTAINERS patch
> 
> Changelog v2:
> - add patches 1,4-12
> 
> Andy Shevchenko (13):
>   NFC: pn544: Switch to devm_acpi_dev_add_driver_gpios()
>   NFC: st21nfca: Add GPIO ACPI mapping table
>   NFC: st21nfca: Get rid of code duplication in ->probe()
>   NFC: fdp: Convert I2C driver to ->probe_new()
>   NFC: fdp: Convert to use devres API
>   NFC: fdp: Add GPIO ACPI mapping table
>   NFC: st-nci: Get rid of platform data
>   NFC: st-nci: Get rid of "interesting" use of interrupt polarity
>   NFC: st-nci: Covert to use GPIO descriptor
>   NFC: st-nci: Use unified device properties API meaningfully
>   NFC: st-nci: Add GPIO ACPI mapping table
>   NFC: st-nci: Get rid of code duplication in ->probe()
>   MAINTAINERS: Remove non-existing NFC platform data files
All patches applied, thanks.

Cheers,
Samuel.
