Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:9990 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499AbZGPQvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 12:51:51 -0400
Received: by qw-out-2122.google.com with SMTP id 8so95265qwh.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 09:51:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20090716T120033-657@post.gmane.org>
References: <loom.20090716T120033-657@post.gmane.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 09:51:31 -0700
Message-ID: <43e72e890907160951w6cad2191tb31fbea7def97306@mail.gmail.com>
Subject: Re: prism54 firmware cannot initialize pcmcia card
To: Dave <dave.mulford@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 5:09 AM, Dave<dave.mulford@gmail.com> wrote:
> First, some generic info about the laptop I'm using
>
> gentoo kernel-2.6.29
> prism54-firmware-2.13.2 (listed as working with in-kernel >=2.6.29 driver)
> yenta_cardbus driver
>
> Everything seems to work. The driver is loaded, the card is recognized, the
> driver requests the correct firmware name, then the firmware seems to have
> issues initializing the card. I have posted the relevant entries in dmesg to
> http://pastebin.com/f7514c9c0
>
> Any help is appreciated. Thanks!

You are using p54 softmac firmware with the old fullmac prism54
driver. You can now use the p54 softmac driver. See:

http://wireless.kernel.org/en/users/Drivers/p54

  Luis
