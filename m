Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751245AbeBAG7B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 01:59:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 5/8] Bluetooth: btrsi: add new rsi bluetooth driver
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-6-git-send-email-amitkarwar@gmail.com>
        <117694D2-5C98-4C40-BF02-FC1EDBF41FE8@holtmann.org>
Date: Thu, 01 Feb 2018 08:58:57 +0200
In-Reply-To: <117694D2-5C98-4C40-BF02-FC1EDBF41FE8@holtmann.org> (Marcel
        Holtmann's message of "Wed, 13 Dec 2017 14:46:02 +0100")
Message-ID: <87mv0tmc0e.fsf@purkki.adurom.net> (sfid-20180201_075906_793061_23654CBF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

>> Redpine bluetooth driver is a thin driver which depends on
>> 'rsi_91x' driver for transmitting and receiving packets
>> to/from device. It creates hci interface when attach() is
>> called from 'rsi_91x' module.
>>=20
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

>> +module_init(rsi_91x_bt_module_init);
>> +module_exit(rsi_91x_bt_module_exit);
>> +MODULE_AUTHOR("Redpine Signals Inc");
>> +MODULE_DESCRIPTION("RSI BT driver");
>> +MODULE_SUPPORTED_DEVICE("RSI-BT");
>> +MODULE_LICENSE("Dual BSD/GPL=E2=80=9D);
>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> Reviewed-by: Marcel Holtmann <marcel@holtmann.org>

So how should we handle the logistics, should all these go via
wireless-drivers-next tree or what's the plan?

--=20
Kalle Valo
