Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37573 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdEaMwx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 08:52:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Norik Dzhandzhapanyan <norikd@ethertronics.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Per chain RSSI reporting
Date: Wed, 31 May 2017 12:52:37 +0000
Message-ID: <87tw41mbnq.fsf@kamboji.qca.qualcomm.com> (sfid-20170531_145256_839626_C1EE2123)
References: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
In-Reply-To: <SN1PR08MB1373BF583E9CE2AA6A0F6381B0FC0@SN1PR08MB1373.namprd08.prod.outlook.com>
        (Norik Dzhandzhapanyan's message of "Fri, 26 May 2017 22:49:45 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Norik Dzhandzhapanyan <norikd@ethertronics.com> writes:

> Add support for per chain RSSI reporting w/smoothing.
>
> Signed-off-by: Norik Dzhandzhapanyan norikd@ethertronics.com
>
>
> --- htt_rx.c.orig  2017-05-26 15:26:37.918504255 -0700
> +++ htt_rx.c        2017-05-26 12:10:33.139809025 -0700
> @@ -825,14 +825,71 @@ static bool ath10k_htt_rx_h_channel(stru
>               return true;
> }

The patch formatting is broken and I can't apply this. Please use git
send-email, more info here:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches

But more importantly:

> The contents of this transmission are Ethertronics Inc. Confidential
> and may contain proprietary or legally privileged information which
> may not be disclosed, copied or distributed without the express
> written consent of Ethertronics Inc. The information is intended to be
> for the use of the individual or entity named on this transmission. If
> you are not the intended recipient, be aware that any disclosure,
> copying, distribution or use of the contents of this information is
> prohibited. If you have received this transmission in error, please
> notify us by telephone immediately so that we can arrange for the
> retrieval of the original documents at no cost to you. Alternatively,
> notify the sender by replying to this transmission and delete the
> message without disclosing it. Thank you

I will never apply a patch which has this kind of disclaimer. The
patches must follow the Developer's Certificate of Origin[1] and not
have any other disclaimer.

[1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html#=
sign-your-work-the-developer-s-certificate-of-origin

--=20
Kalle Valo=
