Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:34151 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3DNN6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 09:58:06 -0400
Received: by mail-pb0-f52.google.com with SMTP id mc8so2087477pbc.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 06:58:05 -0700 (PDT)
Date: Sun, 14 Apr 2013 06:58:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: minimumlaw@rambler.ru, linux-wireless@vger.kernel.org,
	stable@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] Fix transmit power troubles on some Ralink RT30xx cards
Message-ID: <20130414135803.GC13694@kroah.com> (sfid-20130414_155811_137261_AA47059B)
References: <1365936883-19033-1-git-send-email-minimumlaw@rambler.ru>
 <20130414135316.GA14248@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130414135316.GA14248@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 14, 2013 at 03:53:16PM +0200, Stanislaw Gruszka wrote:
> On Sun, Apr 14, 2013 at 02:54:43PM +0400, minimumlaw@rambler.ru wrote:
> > From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
> > 
> > Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
> > value in them EEPROM/EFUSE. In this case, we must use default value,
> > but always used EEPROM/EFUSE value. As result we have tranmitt power
> > range from -10dBm to +6dBm instead 0dBm to +16dBm.
> 
> Thanks for great work on debugging this!
> > Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
> > more for other RT30xx chips.
> >
> > Testen on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
> > embedded Wi-Fi module.
> 
> Signed-off-by: "Alex A. Mihaylov" <minimumlaw@rambler.ru>

You can not just add someone else's Signed-off-by: to a patch, please go
read Documentation/SubmittingPatches for what it is (hint, a legal
statement).  Never do that.  Ever.

