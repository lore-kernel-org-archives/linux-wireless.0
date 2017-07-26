Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34341 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750813AbdGZHwO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 03:52:14 -0400
Date: Wed, 26 Jul 2017 09:52:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        devel@linuxdriverproject.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>,
        Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v1 1/6] efi: Switch to use new generic UUID API
Message-ID: <20170726075212.GB10959@lst.de> (sfid-20170726_095230_195392_DE1DAAD0)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com> <20170719182857.73693-2-andriy.shevchenko@linux.intel.com> <CAKv+Gu8Et3smOv9Of47q6VGa9yn9u+vuhS_1B5yg_QULsS4Obg@mail.gmail.com> <1500979206.29303.228.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500979206.29303.228.camel@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 25, 2017 at 01:40:06PM +0300, Andy Shevchenko wrote:
> Christoph, can we apply this one at least to move things forward?

Id be happy to pick this up for 4.14.  Does everyone involved agree
that the uuid tree is the right one?
