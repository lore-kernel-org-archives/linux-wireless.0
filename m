Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39052 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751832AbeBAIe4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 03:34:56 -0500
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
        <87mv0tmc0e.fsf@purkki.adurom.net>
        <9578979D-0F76-4178-B14D-3C5699039DEB@holtmann.org>
Date: Thu, 01 Feb 2018 10:34:50 +0200
In-Reply-To: <9578979D-0F76-4178-B14D-3C5699039DEB@holtmann.org> (Marcel
        Holtmann's message of "Thu, 1 Feb 2018 09:16:14 +0100")
Message-ID: <87inbhm7kl.fsf@kamboji.qca.qualcomm.com> (sfid-20180201_093500_143163_D5AABED3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

>>> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>>> Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
>> 
>> So how should we handle the logistics, should all these go via
>> wireless-drivers-next tree or what's the plan?
>
> I think they should go via wireless-drivers-next and once you send
> Dave a pull request, I pull back from net-next into bluetooth-next and
> we should be good. Any required fixup for Bluetooth we will do then
> via my tree.

Ok, that sounds good to me.

-- 
Kalle Valo
