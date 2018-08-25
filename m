Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57880 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbeHYMjB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 08:39:01 -0400
Subject: Re: [PATCH 02/17] mt76: rename mt76x2_regs.h
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
 <1535109321-17126-3-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <2172355a-0703-e432-96cb-fba2383c3890@nbd.name> (sfid-20180825_110045_727297_D3340A6C)
Date: Sat, 25 Aug 2018 11:00:39 +0200
MIME-Version: 1.0
In-Reply-To: <1535109321-17126-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-24 13:15, Stanislaw Gruszka wrote:
> MAC registers are the same for mt76x0 and mt76x2. Rename mt76x2_regs.h
> file to reflect that.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x2.h      |   2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2_regs.h | 619 -----------------------
>  drivers/net/wireless/mediatek/mt76/mt76xx_regs.h | 619 +++++++++++++++++++++++
I think mt76xx_regs.h is named too generic. MT7603, MT7628, MT7615 and
all newer chips use a completely different register layout.
I'd prefer to stick with mt76x2_regs for now and use it for x0 as well.

- Felix
