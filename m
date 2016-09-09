Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25284 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbcIIO3a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 10:29:30 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath10k: Padding related clean ups in rx
Date: Fri, 9 Sep 2016 14:29:23 +0000
Message-ID: <87a8fhp2nx.fsf@kamboji.qca.qualcomm.com> (sfid-20160909_162941_270077_7F5451BE)
References: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
In-Reply-To: <1469623006-13178-1-git-send-email-vthiagar@qti.qualcomm.com>
        (Vasanthakumar Thiagarajan's message of "Wed, 27 Jul 2016 18:06:42      +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:

> This patch set adds abstraction for rx_hw_desc processing so that
> we can make use of newer desc fields notifying padding information
> which is done on rx payload. "ath10k: Properly remove padding from
> the start of rx payload" fixes padding related bug in ethernet decap
> mode for QCA99X0, QCA9984 qnd QCA4019 but even fixing this bug will
> not make ethernet decap mode work, there needs to be some more fix
> wich would follow this patch series.
>
> Vasanthakumar Thiagarajan (4):
>   ath10k: Move ath10k_hw_params definition to hw.h
>   ath10k: Add provision for Rx descriptor abstraction
>   ath10k: Properly remove padding from the start of rx payload
>   ath10k: Remove 4-addr padding related hw_param configuration

As Benjamin has these patches on his own set I'm dropping this one.

--=20
Kalle Valo=
