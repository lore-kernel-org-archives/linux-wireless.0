Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58488 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754326AbdG3Rhn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Jul 2017 13:37:43 -0400
Date: Sun, 30 Jul 2017 10:37:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-efi <linux-efi@vger.kernel.org>,
        linux-watchdog@vger.kernel.org, sparmaintainer@unisys.com,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>, devel@linuxdriverproject.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID
 API
Message-ID: <20170730173725.GA20606@kroah.com> (sfid-20170730_193751_154948_A4BA7D46)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
 <1501063301.29303.247.camel@linux.intel.com>
 <20170730153224.GA31755@kroah.com>
 <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 30, 2017 at 08:26:48PM +0300, Andy Shevchenko wrote:
> On Sun, Jul 30, 2017 at 6:32 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jul 26, 2017 at 01:01:41PM +0300, Andy Shevchenko wrote:
> >> On Wed, 2017-07-19 at 21:28 +0300, Andy Shevchenko wrote:
> >> > There are new types and helpers that are supposed to be used in new
> >> > code.
> >> >
> >> > As a preparation to get rid of legacy types and API functions do
> >> > the conversion here.
> >> >
> >> > While here, re-indent couple of lines to increase readability.
> >>
> >> This looks like no user space UUID API is involved, can be routed via
> >> either tree (uuid or staging).
> >>
> >> Anyone to comment?
> >
> > Doesn't apply to the staging tree at all :(
> 
> No surprises, it was cooked against uuid tree in the first place.
> If you agree to take it through staging tree I will prepare a rebased version.
> Does it sound good?

You can take it through the uuid tree if it's easier for you, but then
someone will have to deal with the merge issues...

If it's easier, I can take it to prevent the merge problems.

thanks,

greg k-h
