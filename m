Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:30963 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdGaRWA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 13:22:00 -0400
Message-ID: <1501521625.29303.308.camel@linux.intel.com> (sfid-20170731_192217_174796_3A1DBB81)
Subject: Re: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID
 API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-efi <linux-efi@vger.kernel.org>,
        linux-watchdog@vger.kernel.org, sparmaintainer@unisys.com,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>, devel@linuxdriverproject.org,
        Christoph Hellwig <hch@lst.de>
Date: Mon, 31 Jul 2017 20:20:25 +0300
In-Reply-To: <20170730173725.GA20606@kroah.com>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
         <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
         <1501063301.29303.247.camel@linux.intel.com>
         <20170730153224.GA31755@kroah.com>
         <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w@mail.gmail.com>
         <20170730173725.GA20606@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2017-07-30 at 10:37 -0700, Greg Kroah-Hartman wrote:
> On Sun, Jul 30, 2017 at 08:26:48PM +0300, Andy Shevchenko wrote:
> > On Sun, Jul 30, 2017 at 6:32 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:

> > > Doesn't apply to the staging tree at all :(
> > 
> > No surprises, it was cooked against uuid tree in the first place.
> > If you agree to take it through staging tree I will prepare a
> > rebased version.
> > Does it sound good?
> 
> You can take it through the uuid tree if it's easier for you, but then
> someone will have to deal with the merge issues...
> 
> If it's easier, I can take it to prevent the merge problems.

Yep! There are so many conflicts that would be better just to push
through your tree.

I have just sent a v2 of this patch separately.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
