Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:37270 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933133AbdGST1K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:27:10 -0400
MIME-Version: 1.0
In-Reply-To: <20170719182857.73693-7-andriy.shevchenko@linux.intel.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-7-andriy.shevchenko@linux.intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 19 Jul 2017 21:27:08 +0200
Message-ID: <CAJZ5v0iJNVaUCxu1AfxiWdkLcHFpXzvTD4PQkbuje=XTDTo9Sw@mail.gmail.com> (sfid-20170719_212726_545740_1C23A6E6)
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID API
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        devel@linuxdriverproject.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org,
        "open list:NETWORKING DRIVERS (WIRELESS)"
        <linux-wireless@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 19, 2017 at 8:28 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There are new types and helpers that are supposed to be used in new code.
>
> As a preparation to get rid of legacy types and API functions do
> the conversion here.

Please talk to Mika about this one.

Thanks,
Rafael
