Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35486 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdGZAfD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 20:35:03 -0400
MIME-Version: 1.0
In-Reply-To: <2908341.aERReitNcd@aspire.rjw.lan>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-7-andriy.shevchenko@linux.intel.com>
 <20170725141235.GY2369@lahna.fi.intel.com> <2908341.aERReitNcd@aspire.rjw.lan>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Wed, 26 Jul 2017 03:35:01 +0300
Message-ID: <CAHp75Vd6KenS3vQBgTJL=iE790Rrtzj11gvPK=KLE98bjcPm6w@mail.gmail.com> (sfid-20170726_023754_758972_AC04903E)
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID API
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        devel@linuxdriverproject.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        linux-efi <linux-efi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 26, 2017 at 3:21 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, July 25, 2017 05:12:35 PM Mika Westerberg wrote:
>> On Wed, Jul 19, 2017 at 09:28:57PM +0300, Andy Shevchenko wrote:
>> > There are new types and helpers that are supposed to be used in new code.
>> >
>> > As a preparation to get rid of legacy types and API functions do
>> > the conversion here.
>> >
>> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>> > Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
>>
>> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>
> OK
>
> Andy, do you want me to apply this?

If you would like to.

The patch is now pretty independent since necessary stuff made v4.13-rc1.

-- 
With Best Regards,
Andy Shevchenko
