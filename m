Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52970 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751382AbdKUIpE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 03:45:04 -0500
Subject: Re: [v7,1/3] dt-bindings: net: add mt76 wireless device binding
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20171120193549.80831-2-nbd@nbd.name>
 <20171121070837.AA354607EA@smtp.codeaurora.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <d6e4c888-d6f8-7e20-d27a-a36a3ec01ccf@nbd.name> (sfid-20171121_094530_961937_62C13702)
Date: Tue, 21 Nov 2017 09:45:02 +0100
MIME-Version: 1.0
In-Reply-To: <20171121070837.AA354607EA@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-11-21 08:08, Kalle Valo wrote:
> Felix Fietkau <nbd@nbd.name> wrote:
> 
>> Add documentation describing how device tree can be used to configure
>> wireless chips supported by the mt76 driver.
>> 
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
>> Acked-by: Rob Herring <robh@kernel.org>
> 
> Fails to compile:
> 
> drivers/net/wireless/mediatek/mt76/mac80211.c: In function ‘mt76_led_init’:
> drivers/net/wireless/mediatek/mt76/mac80211.c:111:7: error: implicit declaration of function ‘of_get_child_by_name’ [-Werror=implicit-function-declaration]
>   np = of_get_child_by_name(np, "led");
>        ^
Sorry about that, I must have mixed up something while updating the
patches based on my git tree. Will send out a fixed version later today.

- Felix
