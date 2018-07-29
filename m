Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21402 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbeG2RCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 13:02:09 -0400
Message-ID: <ba5ce706c02be1a48dadd35e1969dbeefc0348f6.camel@linux.intel.com> (sfid-20180729_173128_660062_E4B3020F)
Subject: Re: [PATCH v3] PCI: Add PCI_DEVICE_DATA() macro to fully describe
 device ID entry
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 29 Jul 2018 18:31:17 +0300
In-Reply-To: <c68d62cb07f66c6d82bf958e1d521dd570527d26.camel@linux.intel.com>
References: <20180727204945.60865-1-andriy.shevchenko@linux.intel.com>
         <20180727211041.GF173328@bhelgaas-glaptop.roam.corp.google.com>
         <c68d62cb07f66c6d82bf958e1d521dd570527d26.camel@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2018-07-29 at 15:49 +0300, Andy Shevchenko wrote:
> On Fri, 2018-07-27 at 16:10 -0500, Bjorn Helgaas wrote:

> Do you think variant with ##vend##dev is better? I will update it for
> v4
> if needed.

Okay, I have sent v4 with your comment addressed.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
