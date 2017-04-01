Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:20555 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751991AbdDAXH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 19:07:28 -0400
Date: Sun, 2 Apr 2017 01:07:24 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Andrey Rusalin <arusalin@dev.rtsoft.ru>
Cc: michael.thalmeier@hale.at, linux-wireless@vger.kernel.org,
        linux-nfc@lists.01.org
Subject: Re: [PATCH 0/3] NFC: pn533: fixes for i2c driver
Message-ID: <20170401230712.GJ22034@zurbaran.ger.intel.com> (sfid-20170402_010732_466566_59B9A11C)
References: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

On Wed, Dec 28, 2016 at 08:10:56PM +0300, Andrey Rusalin wrote:
> Each of these patches fix some oops that I met during  
> tests of the driver with itead pn532 nfc module.
> 
> First and third patches related to order of initialization driver,
> where interrupt handler was registered before work queues
> were ready to handle it.
> Also iqr was freed already after work queues were deinitialized.
> 
> Second patch originally sent by Michael Thalmeier.
> I reworked a little bit to make it more readable.
> 
> Andrey Rusalin (3):
>   NFC: pn533: change order of free_irq and dev unregistration
>   NFC: pn533: improve cmd queue handling
>   NFC: pn533: change order operations in dev registation
All 3 patches applied, thanks.

Cheers,
Samuel.
