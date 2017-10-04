Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:40383 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751908AbdJDJEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 05:04:07 -0400
Date: Wed, 04 Oct 2017 17:03:58 +0800
In-Reply-To: <871smjxp46.fsf@kamboji.qca.qualcomm.com>
References: <20171003165944.13056-1-icenowy@aosc.io> <20171003165944.13056-2-icenowy@aosc.io> <871smjxp46.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH v3 1/2] dt-bindings: add device tree binding for Allwinner XR819 SDIO Wi-Fi
To: Kalle Valo <kvalo@codeaurora.org>
CC: Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
From: Icenowy Zheng <icenowy@aosc.io>
Message-ID: <E46F3A20-294A-497E-AF71-C77A67AFDB8C@aosc.io> (sfid-20171004_110421_827147_22CCA979)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



于 2017年10月4日 GMT+08:00 下午5:02:17, Kalle Valo <kvalo@codeaurora.org> 写到:
>Icenowy Zheng <icenowy@aosc.io> writes:
>
>> Allwinner XR819 is a SDIO Wi-Fi chip, which has the functionality to
>use
>> an out-of-band interrupt pin instead of SDIO in-band interrupt.
>>
>> Add the device tree binding of this chip, in order to make it
>possible
>> to add this interrupt pin to device trees.
>>
>> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
>> Acked-by: Rob Herring <robh@kernel.org>
>> ---
>> Changes in v3:
>> - Renames the node name.
>> - Adds ACK from Rob.
>> Changes in v2:
>> - Removed status property in example.
>> - Added required property reg.
>>
>>  .../bindings/net/wireless/allwinner,xr819.txt      | 38
>++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>  create mode 100644
>Documentation/devicetree/bindings/net/wireless/allwinner,xr819.txt
>
>Like I asked already last time, AFAICS there is no upstream xr819
>wireless driver in drivers/net/wireless directory. Do we still accept
>bindings like this for out-of-tree drivers?

See esp8089.

There's also no in-tree driver for it.
