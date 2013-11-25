Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:59112 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3KYWqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 17:46:43 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so2238687bkb.20
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 14:46:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Pi <juanpide@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RTL8188SU monitor mode.
Date: Mon, 25 Nov 2013 23:46:39 +0100
Message-ID: <1422707.OiBfIJAESr@blech> (sfid-20131125_234648_487584_D7180726)
In-Reply-To: <CAEQWovQBVTqLtqZik-P+RCLbXaWSXXLSq1aijn136q=4xfdoaA@mail.gmail.com>
References: <CAEQWovQBVTqLtqZik-P+RCLbXaWSXXLSq1aijn136q=4xfdoaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 25, 2013 02:41:24 PM Pi wrote:
> Does the r92su or the r8712u drivers support monitor mode
> and package injection for the  RTL8188SU chipset?
It depends what you want to do. The original rtl8712 driver (from realtek's
site) has what seems to be a special mode (mp_mode) complete with special 
ioctls, etc... which seems like it was designed with something like this in
mind.

However, I can't tell you if it works and what exactly it does and doesn't.
So far, the best answer is: it might work. However it's also possible that
you need a special firmware and/or a early FPGA/preproduction ASIC for this
feature.

Good Luck!

> Or it won't happen because of hardware limitations?
> Some wifi adapters with very good sensitivity use this chipset.
Well, then I have good news: You have a choice!!! Other vendors are
actively supporting their upstream drivers (and support is what you
want, right?!). Even better, these drivers already provide advanced
channel/site survey statistics and other important features like 5/
10MHz channels, coverage class, ... you name it: they got it... Already!

I'm sure - if you look around a bit - you can find a device which
supports what you need "out of the box".

Hint: Visit the wiki at [0].

Regards,

Christian

[0] <http://wireless.kernel.org/en/users/Drivers>
