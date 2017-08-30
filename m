Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49933 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751318AbdH3N5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 09:57:53 -0400
Date: Wed, 30 Aug 2017 15:57:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
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
Message-ID: <20170830135751.GA32713@lst.de> (sfid-20170830_155922_068771_1E5D5027)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <6349641.0fe8FCM51k@aspire.rjw.lan> <20170830124141.oa32gzbgnafarkrh@infradead.org> <2441703.fLWibNLWr6@aspire.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2441703.fLWibNLWr6@aspire.rjw.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 30, 2017 at 03:46:34PM +0200, Rafael J. Wysocki wrote:
> 3689d3d69072 ACPI: device property: Switch to use new generic UUID API
> 
> in my linux-next branch.  Isn't it this one?

Yes, that should be it.  Somehow my linux-next tree seems to be
a mess through or my git log skills aren't what they used to be
anymore.
