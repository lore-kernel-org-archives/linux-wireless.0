Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:35314 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbeBAIQQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 03:16:16 -0500
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [v5 5/8] Bluetooth: btrsi: add new rsi bluetooth driver
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <87mv0tmc0e.fsf@purkki.adurom.net>
Date: Thu, 1 Feb 2018 09:16:14 +0100
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Message-Id: <9578979D-0F76-4178-B14D-3C5699039DEB@holtmann.org> (sfid-20180201_091620_847517_6A144209)
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
 <1513168977-2121-6-git-send-email-amitkarwar@gmail.com>
 <117694D2-5C98-4C40-BF02-FC1EDBF41FE8@holtmann.org>
 <87mv0tmc0e.fsf@purkki.adurom.net>
To: Kalle Valo <kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

>>> Redpine bluetooth driver is a thin driver which depends on
>>> 'rsi_91x' driver for transmitting and receiving packets
>>> to/from device. It creates hci interface when attach() is
>>> called from 'rsi_91x' module.
>>> 
>>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> 
> [...]
> 
>>> +module_init(rsi_91x_bt_module_init);
>>> +module_exit(rsi_91x_bt_module_exit);
>>> +MODULE_AUTHOR("Redpine Signals Inc");
>>> +MODULE_DESCRIPTION("RSI BT driver");
>>> +MODULE_SUPPORTED_DEVICE("RSI-BT");
>>> +MODULE_LICENSE("Dual BSD/GPL”);
>> 
>> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>> Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
> 
> So how should we handle the logistics, should all these go via
> wireless-drivers-next tree or what's the plan?

I think they should go via wireless-drivers-next and once you send Dave a pull request, I pull back from net-next into bluetooth-next and we should be good. Any required fixup for Bluetooth we will do then via my tree.

Regards

Marcel
