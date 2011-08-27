Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54887 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1H0Ql2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 12:41:28 -0400
Received: by wwf5 with SMTP id 5so4456299wwf.1
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2011 09:41:26 -0700 (PDT)
Message-ID: <4E591E32.7050204@gmail.com> (sfid-20110827_184132_887147_31669CED)
Date: Sat, 27 Aug 2011 18:41:22 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: gregkh@suse.de, linux-wireless@vger.kernel.org,
	devel@linuxdriverproject.org
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <gregkh@suse.de> wrote:

> I always thought that b43 and the staging driver supported different
> devices and had no overlap, which is why I had no problem with it.
> 
> Was I totally mistaken and got this wrong?

There are *three* drivers for the 'same' hw:
wl(proprietary), brcmsmac(staging) and b43(kernel)

http://linuxwireless.org/en/users/Drivers/b43#bcm43xx.2C_b43legacy.2C_b43.2C_softmac.2C..._the_full_story

http://linuxwireless.org/en/users/Drivers/b43#Supported_devices
