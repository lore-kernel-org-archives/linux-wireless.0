Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38850 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387822AbeGWHiT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 03:38:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 04/11] mt76x0: usb files
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
        <1530771142-4118-5-git-send-email-sgruszka@redhat.com>
        <20180705150519.GB17524@localhost.localdomain>
Date: Mon, 23 Jul 2018 09:38:35 +0300
In-Reply-To: <20180705150519.GB17524@localhost.localdomain> (Lorenzo
        Bianconi's message of "Thu, 5 Jul 2018 17:05:20 +0200")
Message-ID: <87va96tq1g.fsf@purkki.adurom.net> (sfid-20180723_083842_800881_ADF6A35B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> On Jul 05, Stanislaw Gruszka wrote:
>> Add usb files of mt76x0 driver.
>> 
>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

[...]

>> +static int mt76x0_suspend(struct usb_interface *usb_intf, pm_message_t state)
>> +{
>> +	struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
>> +
>> +	mt76x0_cleanup(dev);
>
> Is it necessary to deallocate rx queue here in case of a system suspend?

BTW it would really helpful to others if you could edit your quotes. It
takes some time to find your oneliner from a 450 line message.

-- 
Kalle Valo
