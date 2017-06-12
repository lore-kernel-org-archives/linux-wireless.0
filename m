Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12178 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754972AbdFLPiF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 11:38:05 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] Add per chain RSSI reporting.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <CAAV6Hgmjq9DDpcUUTZtDwodUjKrkzjnKSNZ+sK8U=M_AQgr-iQ@mail.gmail.com>
References: <CAAV6Hgmjq9DDpcUUTZtDwodUjKrkzjnKSNZ+sK8U=M_AQgr-iQ@mail.gmail.com>
To: Norik Dzhandzhapanyan <norikd@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <866823ed4ac64b8dae61f791aeb7e6f9@eusanexr01a.eu.qualcomm.com> (sfid-20170612_173816_249892_AE70A7AC)
Date: Mon, 12 Jun 2017 08:37:56 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Norik Dzhandzhapanyan <norikd@gmail.com> wrote:

> Report per chain RSSI to mac80211.
> 
> Signed-off-by: Norik Dzhandzhapanyan <norikd@gmail.com>
> [kvalo@qca.qualcomm.com: fix conflicts and style]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This failed to apply and had quite a few checkpatch warnings. So I recreted the
patch manually:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=5df110e3a093771f23001be2012ab6fa4d87089b

-- 
https://patchwork.kernel.org/patch/9760887/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
