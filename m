Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49553 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751302AbdH3Miw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 08:38:52 -0400
Date: Wed, 30 Aug 2017 14:38:45 +0200
From: Christoph Hellwig <hch@infradead.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20170830123845.lw4vkjbcvivi5hpi@infradead.org> (sfid-20170830_143907_843077_F916CBF0)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
 <1501063301.29303.247.camel@linux.intel.com>
 <20170730153224.GA31755@kroah.com>
 <CAHp75Vf+Us5n2_u94sVGs7xuvfF-qoaG4tvmixvqRARo68TT7w@mail.gmail.com>
 <20170730173725.GA20606@kroah.com>
 <1501521625.29303.308.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501521625.29303.308.camel@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 31, 2017 at 08:20:25PM +0300, Andy Shevchenko wrote:
> Yep! There are so many conflicts that would be better just to push
> through your tree.
> 
> I have just sent a v2 of this patch separately.

Greg, did you pick that patch up?
