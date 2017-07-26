Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cloudserver094114.home.net.pl ([79.96.170.134]:62463 "EHLO
        cloudserver094114.home.net.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751047AbdGZA3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 20:29:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID API
Date: Wed, 26 Jul 2017 02:21:12 +0200
Message-ID: <2908341.aERReitNcd@aspire.rjw.lan> (sfid-20170726_022927_873533_B718E14D)
In-Reply-To: <20170725141235.GY2369@lahna.fi.intel.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-7-andriy.shevchenko@linux.intel.com> <20170725141235.GY2369@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 25, 2017 05:12:35 PM Mika Westerberg wrote:
> On Wed, Jul 19, 2017 at 09:28:57PM +0300, Andy Shevchenko wrote:
> > There are new types and helpers that are supposed to be used in new code.
> > 
> > As a preparation to get rid of legacy types and API functions do
> > the conversion here.
> > 
> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

OK

Andy, do you want me to apply this?

Thanks,
Rafael
