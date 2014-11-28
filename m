Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34876 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1LZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 06:25:45 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so10900999wiw.10
        for <linux-wireless@vger.kernel.org>; Fri, 28 Nov 2014 03:25:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d287u7fv.fsf@kamboji.qca.qualcomm.com>
References: <1416838646-18801-1-git-send-email-michal.kazior@tieto.com>
	<87vbm2whoz.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=56six2CEQ6Rzr7yMEM7UVNQ3RX9UpdgmxMEoG0+kDAA@mail.gmail.com>
	<87d287u7fv.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 28 Nov 2014 12:25:43 +0100
Message-ID: <CA+BoTQ=0929oK8msio-zPj2v2JDZ2+3trg4QqQ-vbYJszwh0CQ@mail.gmail.com> (sfid-20141128_122548_162986_D4316EE6)
Subject: Re: [PATCH 1/3] ath10k: embed supported chip ids in hw_params
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 November 2014 at 08:10, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Hmm.. I have a couple of ideas:
>
> [...]
>
>> 2. Have a dedicatd pci-specific structure:
>>
>>  struct ath10k_pci_supported_chip {
>>    u16 dev_id;
>>    u32 chip_id;
>>  };
>>
>>  struct ath10k_pci_supported_chip ath10k_pci_supported_chips[] = {
>>    { QCA988X_2_0_DEVICE_ID, QCA988X_HW_2_0_CHIP_ID_REV },
>>    // ...
>>  };
>>
>> Probably the simplest and has least impact.
>
> Yeah, this seems to be the best. Can you send v2?

Ok. I'll go with this approach and post a v2 when I'm done.


Michał
