Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f53.google.com ([209.85.221.53]:33634 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbeHXSvG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 14:51:06 -0400
Received: by mail-wr1-f53.google.com with SMTP id v90-v6so7804358wrc.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Aug 2018 08:16:01 -0700 (PDT)
Date: Fri, 24 Aug 2018 17:15:57 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH 00/17] mt76 patches 2018-08-24
Message-ID: <20180824151556.GA32048@localhost.localdomain> (sfid-20180824_171604_374091_A4760A72)
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This is the begin work of integration between mt76x0 and mt76x2.
> 
> Further development can be seen here:
> https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v2
> 
> Stanislaw Gruszka (17):
>   mt76: unify wait_for_mac
>   mt76: rename mt76x2_regs.h
>   mt76: merge mt76x0/regs.h into mt76xx_regs.h
>   mt76: create new mt76xx-lib module for common mt76x{0,2} code
>   mt76: fix mt76xx-lib module license
>   mt76: unify mac_get_key_info
>   mt76: add helpers for register access with mt76_dev struct
>   mt76: unify mac_shared_key_setup
>   mt76: unify mt76xx_mac_wcid_set_key
>   mt76: unify mac_wcid_setup
>   mt76: use mac_wcid_set_drop in mt76x0
>   mt76x0: use mt76_wcid_free in mt76x0
>   mt76: unify mt76xx_vif struct
>   mt76: unify sta stucture part 1
>   mt76: unify sta structure part 2
>   mt76x0: initalize custom tx queues
>   mt76x0: use mt76xx_sta and mt76xx_tx_status

Tested-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
