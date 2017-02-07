Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39377 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752011AbdBGJBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 04:01:11 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/3] ath9k: rename tx_complete_work to hw_check_work
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170202091452.11939-1-nbd@nbd.name>
References: <20170202091452.11939-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <b4d288b79fd544a58b9571e06e9fa1c0@eusanexr01a.eu.qualcomm.com> (sfid-20170207_100114_697170_75D52B0E)
Date: Tue, 7 Feb 2017 01:01:07 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> Also include common MAC alive check. This should make the hang checks
> more reliable for modes where beacons are not sent and is used as a
> starting point for further hang check improvements
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

3 patches applied to ath-next branch of ath.git, thanks.

d63ffc45c5d3 ath9k: rename tx_complete_work to hw_check_work
a34d0a0da1ab ath9k_hw: check if the chip failed to wake up
3a5e969bb2f6 ath9k: fix race condition in enabling/disabling IRQs

-- 
https://patchwork.kernel.org/patch/9551439/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
