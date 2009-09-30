Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:47167 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZI3LSk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 07:18:40 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1348599fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 04:18:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909301304.33903.schmidtreiner@gmx.net>
References: <200909301304.33903.schmidtreiner@gmx.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 30 Sep 2009 13:18:24 +0200
Message-ID: <69e28c910909300418qa239fa9k5cb3f223df210ee7@mail.gmail.com>
Subject: Re: B43 Module on Compaq HP615 Laptop
To: Reiner Schmidt <schmidtreiner@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You need to unload the old ssb prior to loading b43 (which loads an
updated ssb).

On Wed, Sep 30, 2009 at 1:04 PM, Reiner Schmidt <schmidtreiner@gmx.net> wrote:
> Hello,
> I am trying to install the newest compat-wireless package (from 30.09.2009)
> onto this notebook. It has a Broadcom 4312 compatible  WLAN device on it .
> Its id is:14e4:4315.
> I use s debian sidux distribution with an 2.6.29-4 liquorix-kernel.
> Unfortunately I can currently use newer kernels on this notebook because it
> wouldn't boot up. Tried several 2.6.30 and -31 kernels up too 2.6.31-1.

Please report any error messages it prints.

>
> Compiling the package works so far but when loading the module b43 manually or
> via /etc/modules it complains heavily about ssb-related issues.
>
>
>> b43: disagrees about version of symbol ssb_device_is_enabled
>> b43: Unknown symbol ssb_device_is_enabled
>> b43: Unknown symbol ssb_pmu_set_ldo_paref
>> b43: disagrees about version of symbol ssb_pcicore_dev_irqvecs_enable
>> b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
>> b43: disagrees about version of symbol ssb_bus_may_powerdown
>> b43: Unknown symbol ssb_bus_may_powerdown
>> b43: disagrees about version of symbol ssb_dma_free_consistent
>> b43: Unknown symbol ssb_dma_free_consistent
>> b43: disagrees about version of symbol ssb_bus_suspend
>> b43: Unknown symbol ssb_bus_suspend
>> b43: disagrees about version of symbol ssb_bus_unregister
>> b43: Unknown symbol ssb_bus_unregister
>> b43: disagrees about version of symbol ssb_bus_resume
>> b43: Unknown symbol ssb_bus_resume
>> b43: disagrees about version of symbol ssb_set_devtypedata
>> b43: Unknown symbol ssb_set_devtypedata
>> b43: disagrees about version of symbol ssb_device_disable
>> b43: Unknown symbol ssb_device_disable
>> b43: Unknown symbol ssb_pmu_set_ldo_voltage
>> b43: disagrees about version of symbol ssb_dma_alloc_consistent
>> b43: Unknown symbol ssb_dma_alloc_consistent
>> b43: disagrees about version of symbol ssb_dma_set_mask
>> b43: Unknown symbol ssb_dma_set_mask
>> b43: disagrees about version of symbol ssb_device_enable
>> b43: Unknown symbol ssb_device_enable
>> b43: disagrees about version of symbol ssb_driver_unregister
>> b43: Unknown symbol ssb_driver_unregister
>> b43: disagrees about version of symbol __ssb_driver_register
>> b43: Unknown symbol __ssb_driver_register
>> b43: disagrees about version of symbol ssb_bus_pcmciabus_register
>> b43: Unknown symbol ssb_bus_pcmciabus_register
>> b43: disagrees about version of symbol ssb_bus_powerup
>> b43: Unknown symbol ssb_bus_powerup
>> b43: disagrees about version of symbol ssb_dma_translation
>> b43: Unknown symbol ssb_dma_translation
>
> Is this a real bug or do Ihave to submit additional prameter for the module
> when I load it?
> If so, where can I find those otions ?
>
> Kind regards
>
> Reiner Schmidt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
