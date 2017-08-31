Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:4950 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750895AbdHaMU5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:20:57 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/7] wil6210: ratelimit errors in TX/RX interrupts
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1503947927-18877-2-git-send-email-qca_merez@qca.qualcomm.com>
References: <1503947927-18877-2-git-send-email-qca_merez@qca.qualcomm.com>
To: Maya Erez <qca_merez@qca.qualcomm.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Lior David <qca_liord@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>
Message-ID: <14f9ca73ace149dda4d2f0ca465946b8@euamsexm01a.eu.qualcomm.com> (sfid-20170831_142100_757528_112D4095)
Date: Thu, 31 Aug 2017 14:20:49 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <qca_merez@qca.qualcomm.com> wrote:

> Sometimes there is a firmware crash but the hardware
> is not fully stopped and continue to send TX/RX interrupts.
> This can cause an overload of messages which can bring the
> host down. Add ratelimit to these error messages to fix this.
> 
> Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

7 patches applied to ath-next branch of ath.git, thanks.

40cbd88be702 wil6210: ratelimit errors in TX/RX interrupts
5f591dac9f20 wil6210: make debugfs compilation optional
761f8e4d463e wil6210: align to latest auto generated wmi.h
1490846d256a wil6210: move pre-FW configuration to separate function
7086d861753b wil6210: clear PAL_UNIT_ICR part of device reset
d83ad4c4fd78 wil6210: increase connect timeout
69fecf599f48 wil6210: ensure P2P device is stopped before removing interface

-- 
https://patchwork.kernel.org/patch/9926041/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
