Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.131]:55734 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751082AbdBXMVU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 07:21:20 -0500
Message-ID: <58B02527.6090400@rock-chips.com> (sfid-20170224_132158_047997_F76F407A)
Date: Fri, 24 Feb 2017 20:20:55 +0800
From: jeffy <jeffy.chen@rock-chips.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@chromium.org>,
        Rajat Jain <rajatja@google.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 3/3] mwifiex: wake system up when receives a wake irq
References: <1487917471-5501-1-git-send-email-jeffy.chen@rock-chips.com> <1487917471-5501-3-git-send-email-jeffy.chen@rock-chips.com> <87d1e726p5.fsf@codeaurora.org>
In-Reply-To: <87d1e726p5.fsf@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 02/24/2017 07:01 PM, Kalle Valo wrote:
> Jeffy Chen <jeffy.chen@rock-chips.com> writes:
>
>> Currrently we are disabling this wake irq after receiving it. If this
>> happens before we finish suspend and the pm event check is disabled,
>> the system will continue suspending, and this irq would not work again.
>>
>> We may need to abort system suspend to avoid that.
>>
>> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> I only see patch 3 in patchwork. Where are patches 1 and 2?
>


the other two are much like this one, but for bluetooth :)

please check:

https://patchwork.kernel.org/patch/9589455 New          [1/3] btusb: 
wake system up when receives a wake irq
https://patchwork.kernel.org/patch/9589453 New          [2/3] btmrvl: 
wake system up when receives a wake irq
https://patchwork.kernel.org/patch/9589457 New          [3/3] mwifiex: 
wake system up when receives a wake irq



(sorry, this is a resent mail, because the last one was rejected due to 
wrong format)
