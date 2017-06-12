Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23190 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752065AbdFLU4X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 16:56:23 -0400
Date: Mon, 12 Jun 2017 22:56:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 00/12] NFC: clean up for ACPI GPIO usage
Message-ID: <20170612205620.GC6272@zurbaran.ger.intel.com> (sfid-20170612_225626_591134_368D494D)
References: <20170605202009.78561-1-andriy.shevchenko@linux.intel.com>
 <1497281772.22624.124.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1497281772.22624.124.camel@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy,

On Mon, Jun 12, 2017 at 06:36:12PM +0300, Andy Shevchenko wrote:
> On Mon, 2017-06-05 at 23:19 +0300, Andy Shevchenko wrote:
> > This clean up series to NFC drivers that are using GPIOs on ACPI
> > enabled
> > platforms. Since GPIO ACPI library goes stricter about requesting
> > resources we need to amend drivers for that. Here we are for NFC
> > subsystem.
> > 
> > While doing above, get rid of legacy and unused platform data as well
> > as
> > some artificial IDs.
> 
> Samuel, anything to comment?
I will get to my pending NFC patches during the week.

Cheers,
Samuel.
