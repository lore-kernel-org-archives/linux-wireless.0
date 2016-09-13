Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49418 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbcIMEuw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 00:50:52 -0400
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix rfc1042 header retrieval in QCA4019 with eth
 decap mode
Date: Tue, 13 Sep 2016 04:50:43 +0000
Message-ID: <57D78591.9050107@qti.qualcomm.com> (sfid-20160913_065057_209051_E5976CFF)
References: <1469623085-13942-1-git-send-email-vthiagar@qti.qualcomm.com>
 <87fup5m8x5.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87fup5m8x5.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 12 September 2016 09:01 PM, Valo, Kalle wrote:
> Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:
>
>> Chipset from QCA99X0 onwards (QCA99X0, QCA9984, QCA4019 & future)
>> rx_hdr_status is not padded to align in 4-byte boundary. Define a
>> new hw_params field to handle different alignment behaviour between
>> different hw. This patch fixes improper retrieval of rfc1042 header
>> with QCA4019. This patch along with "ath10k: Properly remove padding
>> from the start of rx payload" will fix traffic failure in ethernet
>> decap mode for QCA4019.
>>
>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
>
> There were some conflicts, I fixed them in the pending branch. Please
> check my changes:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=3Dpe=
nding&id=3Dd0d9e40216e1a8edd2f3b387b96aad62c3a49add
>

Looks fine, thanks.

Vasanth=
