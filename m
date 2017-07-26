Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37691 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdGZIgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 04:36:33 -0400
Received: by mail-it0-f54.google.com with SMTP id v127so64214856itd.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jul 2017 01:36:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170726075212.GB10959@lst.de>
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-2-andriy.shevchenko@linux.intel.com>
 <CAKv+Gu8Et3smOv9Of47q6VGa9yn9u+vuhS_1B5yg_QULsS4Obg@mail.gmail.com>
 <1500979206.29303.228.camel@linux.intel.com> <20170726075212.GB10959@lst.de>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 26 Jul 2017 09:36:32 +0100
Message-ID: <CAKv+Gu8Ua5A0N6vj_J65ss6eHdest1_+_Jwp7enoeqAsccugYQ@mail.gmail.com> (sfid-20170726_103654_742657_1F2D039B)
Subject: Re: [PATCH v1 1/6] efi: Switch to use new generic UUID API
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        devel@linuxdriverproject.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Wunner <lukas@wunner.de>,
        Matt Fleming <matt@codeblueprint.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 July 2017 at 08:52, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Jul 25, 2017 at 01:40:06PM +0300, Andy Shevchenko wrote:
>> Christoph, can we apply this one at least to move things forward?
>
> Id be happy to pick this up for 4.14.  Does everyone involved agree
> that the uuid tree is the right one?

Fine by me for EFI
