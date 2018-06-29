Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36752 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbeF2Jn4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:43:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [1/6] qtnfmac: implement net_device_ops callback to set MAC address
References: <20180531091102.28666-2-sergey.matyukevich.os@quantenna.com>
        <20180627155439.481E76034E@smtp.codeaurora.org>
        <20180629092654.shzir2mfmlp5luf5@bars>
Date: Fri, 29 Jun 2018 12:43:49 +0300
In-Reply-To: <20180629092654.shzir2mfmlp5luf5@bars> (Sergey Matyukevich's
        message of "Fri, 29 Jun 2018 12:26:56 +0300")
Message-ID: <87d0waexm2.fsf@codeaurora.org> (sfid-20180629_114447_906308_9A1F405A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> wrote:
>> 
>> > From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>> >
>> > Implement net_device_ops::ndo_set_mac_address callback to allow for
>> > setting interface MAC address. Implementation is done through existing
>> > CHANGE_INTF firmware command. All validation is to be done by firmware.
>> >
>> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>> 
>> 2 patches applied to wireless-drivers-next.git, thanks.
>> 
>> ed9f34bb9d33 qtnfmac: implement net_device_ops callback to set MAC address
>> 6fbef9540af0 qtnfmac: enable source MAC address randomization support
>
> Hello Kalle,
>
> I see the other 4 patches in this series are in 'Deferred' state. Could you
> please clarify what that means. Do you have any concerns about those
> remaining patches or any actions are needed from our side ?

I saw there was a comment on one patch and other patch used vendor
commands which I need to review carefully. I didn't have time at the
time so I put them to deferred and try to get back soon.

-- 
Kalle Valo
