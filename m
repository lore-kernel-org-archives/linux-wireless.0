Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:50716 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaJOTeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 15:34:36 -0400
Received: by mail-qc0-f177.google.com with SMTP id c9so1560342qcz.8
        for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2014 12:34:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Oct 2014 15:34:35 -0400
Message-ID: <CANa-JWyxT0LDwmhS-G=exHbHMipBr51sRyazH9XA5dnUZEjKRw@mail.gmail.com> (sfid-20141015_213442_465167_34A731E9)
Subject: ipw2200 driver in kernels 3+
From: Frank Langille <flangille@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, my apologies if I am sending this email to the wrong place.

I recently started toying with an old Dell laptop that uses the very
old ipw2200 intel network driver/firmware mentioned above.

I think support for this item remains in the kernel, as indicated by
the continued existence of
/linux/drivers/net/wireless/ipw2X00/ipw2200.c and ipw2200.h and
corresponding firmware. However, the menuconfig option to select this
driver seems to have disappeared sometime after kernel 3.4.104, which
is the last longterm version I can see that allows me to include the
driver in my build.

Is it possible to have the option made available again? I realize the
request is trivial but think it's worth mentioning, having lost a few
hairs trying to understand what was going on  :)

Cheers,

Frank
