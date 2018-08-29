Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40852 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbeH2QYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 12:24:41 -0400
Subject: Re: [PATCH v3 00/16] mt76 patches 2018-08-24 v3
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <52aac72b-f1d3-d1d5-dc19-308003a26a72@nbd.name> (sfid-20180829_142804_139252_AF5B1867)
Date: Wed, 29 Aug 2018 14:27:58 +0200
MIME-Version: 1.0
In-Reply-To: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-29 13:16, Stanislaw Gruszka wrote:
> This is the begin work of integration between mt76x0 and mt76x2.
> 
> Further development can be seen here:
> https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v2
> 
> v2 -> v3:
> - merge module licence fix patch to patch that add new module
> v1 -> v2:
> - rename mt76xx to mt76x02 to reflect that common code is for mt76x0
>   and mt76x2 only, not for new chips.
> - fixup 'stucture typo' in one patch
> 
> Stanislaw Gruszka (17):
>   mt76: unify wait_for_mac
>   mt76: rename mt76x2_regs.h
>   mt76: merge mt76x0/regs.h into mt76x02_regs.h
>   mt76: create new mt76x02-lib module for common mt76x{0,2} code
>   mt76: fix mt76x02-lib module license
>   mt76: unify mac_get_key_info
>   mt76: add helpers for register access with mt76_dev struct
>   mt76: unify mac_shared_key_setup
>   mt76: unify mt76x02_mac_wcid_set_key
>   mt76: unify mac_wcid_setup
>   mt76: use mac_wcid_set_drop in mt76x0
>   mt76x0: use mt76_wcid_free in mt76x0
>   mt76: unify mt76x02_vif struct
>   mt76: unify sta structure part 1
>   mt76: unify sta structure part 2
>   mt76x0: initalize custom tx queues
>   mt76x0: use mt76x02_sta and mt76x02_tx_status
For the series:

Acked-by: Felix Fietkau <nbd@nbd.name>

- Felix
