Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38376 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754256AbdASUac (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 15:30:32 -0500
Received: by mail-wm0-f52.google.com with SMTP id r144so11677913wme.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 12:30:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87efzyhkup.fsf@purkki.adurom.net>
References: <20170113052937.12538-1-matt@ranostay.consulting>
 <20170113052937.12538-3-matt@ranostay.consulting> <CAPDyKFpcKuybQmhqCkaAkOM5d+ubU8O8=adLm+PXwc=+N87vng@mail.gmail.com>
 <87efzyhkup.fsf@purkki.adurom.net>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 19 Jan 2017 21:30:29 +0100
Message-ID: <CAPDyKFrHvYNOCfAjASEHz75fVcaqt5fptFaqWp5nVPFnHuHV1g@mail.gmail.com> (sfid-20170119_213224_132783_77B26D7B)
Subject: Re: [PATCH v3 2/2] mmc: pwrseq: add support for Marvell SD8787 chip
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Matt Ranostay <matt@ranostay.consulting>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Shawn Lin <shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 January 2017 at 21:10, Kalle Valo <kvalo@codeaurora.org> wrote:
> Ulf Hansson <ulf.hansson@linaro.org> writes:
>
>> Twisting my head around how this could be integrated smoothly into
>> pwrseq simple. No, I just can find a good way forward without messing
>> up pwrseq simple itself.
>>
>> So, for now I decided (once more :-), that let's keep this as separate driver!
>>
>> Perhaps, following device specific mmc pwrseq drivers will needs
>> something similar, but in such case we can look into that then.
>> Thinking about cw1200 for example.
>>
>> Let's get Rob's ack for the DT bindings, seems almost there, then I
>> will queue this.
>
> Just to confirm, you will take the whole set (including the bindings
> patch)?

Yes, correct.

Kind regards
Uffe
