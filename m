Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60946 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdH3Mlp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 08:41:45 -0400
Date: Wed, 30 Aug 2017 14:41:41 +0200
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
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
Subject: Re: [PATCH v1 6/6] device property: Switch to use new generic UUID
 API
Message-ID: <20170830124141.oa32gzbgnafarkrh@infradead.org> (sfid-20170830_144200_707493_925544E4)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <2908341.aERReitNcd@aspire.rjw.lan>
 <CAHp75Vd6KenS3vQBgTJL=iE790Rrtzj11gvPK=KLE98bjcPm6w@mail.gmail.com>
 <6349641.0fe8FCM51k@aspire.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6349641.0fe8FCM51k@aspire.rjw.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 26, 2017 at 02:27:44AM +0200, Rafael J. Wysocki wrote:
> > >> > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > >> > Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
> > >>
> > >> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > >
> > > OK
> > >
> > > Andy, do you want me to apply this?
> > 
> > If you would like to.
> > 
> > The patch is now pretty independent since necessary stuff made v4.13-rc1.
> 
> OK

This didn't seem to make it into linux-next so far, though.
