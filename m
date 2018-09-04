Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbeIDM3z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 08:29:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH v3 01/16] mt76: unify wait_for_mac
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1535541407-27149-2-git-send-email-sgruszka@redhat.com>
References: <1535541407-27149-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Message-Id: <20180904080556.161DA60710@smtp.codeaurora.org> (sfid-20180904_100559_138585_FA9C95AD)
Date: Tue,  4 Sep 2018 08:05:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Create new mt76x02_mac.h for common mac functions of mt76x0 and mt76x2
> and unity wait_for_mac for both drivers.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

16 patches applied to wireless-drivers-next.git, thanks.

2735a6dd7df3 mt76: unify wait_for_mac
89e1b1bc075a mt76: rename mt76x2_regs.h
797ea2407825 mt76: merge mt76x0/regs.h into mt76x02_regs.h
108a4861ef19 mt76: create new mt76x02-lib module for common mt76x{0,2} code
c378f2473466 mt76: unify mac_get_key_info
d413127359c3 mt76: add helpers for register access with mt76_dev struct
047aed1c38cf mt76: unify mac_shared_key_setup
46436b5ef9dd mt76: unify mac_wcid_set_key
32bb405fe2bc mt76: unify mac_wcid_setup
516ea2a2a9d4 mt76: use mac_wcid_set_drop in mt76x0
459e237f14cd mt76x0: use mt76_wcid_free in mt76x0
98ff26e5e217 mt76: unify mt76x02_vif struct
f5a7f126e5fe mt76: unify sta structure part 1
b2d91fb30223 mt76: unify sta structure part 2
78dae93fd8ff mt76x0: initalize custom tx queues
16c8a792ea44 mt76x0: use mt76x02_sta and mt76x02_tx_status

-- 
https://patchwork.kernel.org/patch/10579835/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
