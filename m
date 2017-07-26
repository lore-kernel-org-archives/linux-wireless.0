Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:13949 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbdGZKDb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 06:03:31 -0400
Message-ID: <1501063383.29303.248.camel@linux.intel.com> (sfid-20170726_120347_105777_35504D89)
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID
 API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        devel@linuxdriverproject.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        linux-efi <linux-efi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>
Date: Wed, 26 Jul 2017 13:03:03 +0300
In-Reply-To: <6349641.0fe8FCM51k@aspire.rjw.lan>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
         <2908341.aERReitNcd@aspire.rjw.lan>
         <CAHp75Vd6KenS3vQBgTJL=iE790Rrtzj11gvPK=KLE98bjcPm6w@mail.gmail.com>
         <6349641.0fe8FCM51k@aspire.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-07-26 at 02:27 +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 26, 2017 03:35:01 AM Andy Shevchenko wrote:
> > On Wed, Jul 26, 2017 at 3:21 AM, Rafael J. Wysocki <rjw@rjwysocki.ne
> > t> wrote:

> > > Andy, do you want me to apply this?
> > 
> > If you would like to.
> > 
> > The patch is now pretty independent since necessary stuff made
> > v4.13-rc1.
> 
> OK

Thanks!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
