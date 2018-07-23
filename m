Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56486 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388043AbeGWKHs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jul 2018 06:07:48 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 04/11] mt76x0: usb files
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
        <1530771142-4118-5-git-send-email-sgruszka@redhat.com>
        <20180705150519.GB17524@localhost.localdomain>
        <87va96tq1g.fsf@purkki.adurom.net>
        <CAJ0CqmV_pPrKnRvcCrn-pUNGgJ9bDoFY+H2u0eokOayX7N08oA@mail.gmail.com>
Date: Mon, 23 Jul 2018 12:07:30 +0300
In-Reply-To: <CAJ0CqmV_pPrKnRvcCrn-pUNGgJ9bDoFY+H2u0eokOayX7N08oA@mail.gmail.com>
        (Lorenzo Bianconi's message of "Mon, 23 Jul 2018 10:57:02 +0200")
Message-ID: <87pnzexqul.fsf@codeaurora.org> (sfid-20180723_110739_349432_082D4820)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>>
>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>>
>> > On Jul 05, Stanislaw Gruszka wrote:
>> >> Add usb files of mt76x0 driver.
>> >>
>> >> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>>
>> [...]
>>
>> >> +static int mt76x0_suspend(struct usb_interface *usb_intf, pm_message_t state)
>> >> +{
>> >> +    struct mt76x0_dev *dev = usb_get_intfdata(usb_intf);
>> >> +
>> >> +    mt76x0_cleanup(dev);
>> >
>> > Is it necessary to deallocate rx queue here in case of a system suspend?
>>
>> BTW it would really helpful to others if you could edit your quotes. It
>> takes some time to find your oneliner from a 450 line message.
>
> Ack sorry, I will be more verbose next time :).

I think you misunderstood, I actually was asking to be less verbose :)

The oneliner was just fine. I was just suggesting that instead of
sending a message with 400 lines trim the unnecessary quotation and just
send a shorter 50 line message. That way you save a lot of time (and
avoid frustration) for the people reading your mail.

-- 
Kalle Valo
