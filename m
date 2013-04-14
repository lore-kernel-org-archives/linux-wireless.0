Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:56229 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3DNNcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 09:32:54 -0400
Received: by mail-pb0-f53.google.com with SMTP id un15so2075722pbc.26
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 06:32:54 -0700 (PDT)
Date: Sun, 14 Apr 2013 06:32:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: minimumlaw@rambler.ru
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Fix transmit power troubles on some Ralink RT30xx cards
Message-ID: <20130414133251.GA13694@kroah.com> (sfid-20130414_153259_616161_7D6B9353)
References: <1365936883-19033-1-git-send-email-minimumlaw@rambler.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365936883-19033-1-git-send-email-minimumlaw@rambler.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 14, 2013 at 02:54:43PM +0400, minimumlaw@rambler.ru wrote:
> From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>
> 
> Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
> value in them EEPROM/EFUSE. In this case, we must use default value,
> but always used EEPROM/EFUSE value. As result we have tranmitt power
> range from -10dBm to +6dBm instead 0dBm to +16dBm.
> 
> Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
> more for other RT30xx chips.
> 
> Testen on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
> embedded Wi-Fi module.
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
