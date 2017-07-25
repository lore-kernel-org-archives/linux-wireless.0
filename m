Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7846 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbdGYOOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 10:14:34 -0400
Date: Tue, 25 Jul 2017 17:12:35 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID
 API
Message-ID: <20170725141235.GY2369@lahna.fi.intel.com> (sfid-20170725_161544_971935_E49FE725)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-7-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170719182857.73693-7-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 19, 2017 at 09:28:57PM +0300, Andy Shevchenko wrote:
> There are new types and helpers that are supposed to be used in new code.
> 
> As a preparation to get rid of legacy types and API functions do
> the conversion here.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
