Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35779 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbeGTVTU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jul 2018 17:19:20 -0400
Received: by mail-io0-f196.google.com with SMTP id w11-v6so5392815iob.2
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jul 2018 13:29:27 -0700 (PDT)
MIME-Version: 1.0
References: <1532088098-8483-1-git-send-email-ajay.kathat@microchip.com> <1532088098-8483-5-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1532088098-8483-5-git-send-email-ajay.kathat@microchip.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 20 Jul 2018 22:29:14 +0200
Message-ID: <CACRpkdb8eBPUdRU7DMMY_X+Qxqz5eV3rsGwcBVxd89q5_jix9w@mail.gmail.com> (sfid-20180720_222930_884682_714FACFE)
Subject: Re: [PATCH 4/4] staging: wilc1000: use descriptor-based interface for GPIO
To: ajay.kathat@microchip.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        devel@driverdev.osuosl.org, Greg KH <gregkh@linuxfoundation.org>,
        ganesh.krishna@microchip.com, venkateswara.kaja@microchip.com,
        aditya.shankar@microchip.com, adham.abozaeid@microchip.com,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 20, 2018 at 2:02 PM Ajay Singh <ajay.kathat@microchip.com> wrote:

> Now making use of descriptor-based interface instead of integer-based
> interface for IRQ GPIO.
> Added device tree binding reference for WILC SDIO and SPI interface
> module. Also moved the code to free gpio descriptor in module remove
> as the reference was fetched in probe function.
> Updated the TODO file
>
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Ajay!

Yours,
Linus Walleij
