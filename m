Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdH3NLk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 09:11:40 -0400
Date: Wed, 30 Aug 2017 15:11:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        devel@driverdev.osuosl.org, linux-efi <linux-efi@vger.kernel.org>,
        linux-watchdog@vger.kernel.org, sparmaintainer@unisys.com,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>, devel@linuxdriverproject.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID
 API
Message-ID: <20170830131143.GB12924@kroah.com> (sfid-20170830_151155_040729_242C93F4)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
 <1501063301.29303.247.camel@linux.intel.com>
 <20170730153224.GA31755@kroah.com>
 <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w@mail.gmail.com>
 <20170730173725.GA20606@kroah.com>
 <1501521625.29303.308.camel@linux.intel.com>
 <20170830123845.lw4vkjbcvivi5hpi@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170830123845.lw4vkjbcvivi5hpi@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 30, 2017 at 02:38:45PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 31, 2017 at 08:20:25PM +0300, Andy Shevchenko wrote:
> > Yep! There are so many conflicts that would be better just to push
> > through your tree.
> > 
> > I have just sent a v2 of this patch separately.
> 
> Greg, did you pick that patch up?

Yes, it's already in my tree and in linux-next.

thanks,

greg k-h
