Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48252 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932172AbdDEIdf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 04:33:35 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k_hw: fix channel maximum power level test
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170322194240.1488-1-nbd@nbd.name>
References: <20170322194240.1488-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>,
        <stable@vger.kernel.org>
Message-ID: <cd3e7d5a771d446c9b91a19fc71cc876@euamsexm01a.eu.qualcomm.com> (sfid-20170405_103633_809824_B4687C99)
Date: Wed, 5 Apr 2017 10:33:27 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> The tx power applied by set_txpower is limited by the CTL (conformance
> test limit) entries in the EEPROM. These can change based on the user
> configured regulatory domain.
> Depending on the EEPROM data this can cause the tx power to become too
> limited, if the original regdomain CTLs impose lowr limits than the CTLs
> of the user configured regdomain.
> 
> To fix this issue, set the initial channel limits without any CTL
> restrictions and only apply the CTL at run time when setting the channel
> and the real tx power.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Failed to apply:

error: patch failed: drivers/net/wireless/ath/ath9k/hw.c:2937
error: drivers/net/wireless/ath/ath9k/hw.c: patch does not apply
stg import: Diff does not apply cleanly

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9639921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
