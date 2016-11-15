Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29811 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752174AbcKONjS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 08:39:18 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "tamizhchelvam@codeaurora.org" <tamizhchelvam@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 3/4] dt: bindings: add new dt entry for BTCOEX feature in
 qcom, ath10k.txt
Date: Tue, 15 Nov 2016 13:39:08 +0000
Message-ID: <87twb8q2v8.fsf@kamboji.qca.qualcomm.com> (sfid-20161115_143922_670440_9C5B72E0)
References: <1478617462-28188-1-git-send-email-c_traja@qti.qualcomm.com>
In-Reply-To: <1478617462-28188-1-git-send-email-c_traja@qti.qualcomm.com> (c.
        traja's message of "Tue, 8 Nov 2016 20:34:22 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding devicetree list)

<c_traja@qti.qualcomm.com> writes:

> From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
>
> There two things done in this patch.
>
> 1) 'btcoex_support' flag for BTCOEX feature support by the hardware.
> 2) 'wlan_btcoex_gpio' is used to fill wlan priority pin number for
>    BTCOEX priority feature support.
>
> Signed-off-by: Tamizh chelvam <tamizhchelvam@codeaurora.org>
> ---
>  .../bindings/net/wireless/qcom,ath10k.txt          |    4 ++++
>  1 file changed, 4 insertions(+)

As this changes the device tree bindings you need to CC the device tree
list. Please resend the whole patchset (and mark it as v2).

--=20
Kalle Valo=
