Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cloudserver094114.home.net.pl ([79.96.170.134]:44166 "EHLO
        cloudserver094114.home.net.pl" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751500AbdGZAfo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 20:35:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
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
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID API
Date: Wed, 26 Jul 2017 02:27:44 +0200
Message-ID: <6349641.0fe8FCM51k@aspire.rjw.lan> (sfid-20170726_023604_005440_6E1D3753)
In-Reply-To: <CAHp75Vd6KenS3vQBgTJL=iE790Rrtzj11gvPK=KLE98bjcPm6w@mail.gmail.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <2908341.aERReitNcd@aspire.rjw.lan> <CAHp75Vd6KenS3vQBgTJL=iE790Rrtzj11gvPK=KLE98bjcPm6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 26, 2017 03:35:01 AM Andy Shevchenko wrote:
> On Wed, Jul 26, 2017 at 3:21 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, July 25, 2017 05:12:35 PM Mika Westerberg wrote:
> >> On Wed, Jul 19, 2017 at 09:28:57PM +0300, Andy Shevchenko wrote:
> >> > There are new types and helpers that are supposed to be used in new code.
> >> >
> >> > As a preparation to get rid of legacy types and API functions do
> >> > the conversion here.
> >> >
> >> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >> > Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> >>
> >> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > OK
> >
> > Andy, do you want me to apply this?
> 
> If you would like to.
> 
> The patch is now pretty independent since necessary stuff made v4.13-rc1.

OK
