Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:44592 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3KALvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 07:51:19 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so3832866wes.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 04:51:18 -0700 (PDT)
From: Peter Wu <lekensteyn@gmail.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: Fred <mrmocool@gmx.de>, linux-wireless@vger.kernel.org
Subject: Re: Broadcom brcm80211 monitor mode
Date: Fri, 01 Nov 2013 12:51:15 +0100
Message-ID: <1979741.aijnk7UbWX@al> (sfid-20131101_125123_468981_AA9C5100)
In-Reply-To: <5012C8F5.5070500@broadcom.com>
References: <CAN+AqrXRuBQZ9Hvnd=sdauFdo1e5eYWBiyo8f2WFDy8EBLGvEQ@mail.gmail.com> <loom.20120727T010814-118@post.gmane.org> <5012C8F5.5070500@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 July 2012 09:59:33 Franky Lin wrote:
> On 07/26/2012 04:12 PM, Fred wrote:
> > Franky Lin <frankyl@...> writes:
> >> However, I do plan to work on the monitor mode support on the firmware
> >> for SDIO dongle as a leisure project although I don't have a schedule for
> >> it. I will announce it on the mail list when it's ready. Stay tuned :)> 
> > Any news on this? :)
> 
> No, I still don't have time get to it.

Since there are no messages on this, I guess you did not get to start it?

There is a RE effort on https://code.google.com/p/bcmon/ that looks very 
hacky.

> > Seems like the Galaxy S3 uses BCM4330 as well.
> 
> Sorry, wrong answer. :(

The Samsung Galaxy S3 (i9300) uses BCM4334 (again SDIO interface, so fullmac). 
I have not tested the brcmfmac driver, but if anyone tries to do so, you might 
need the patch at http://marc.info/?l=linux-wireless&m=136881782700636.

Regards,
Peter
