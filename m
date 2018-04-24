Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60818 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752985AbeDXRcC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:32:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] mt76x2: remove unnecessary MT_TX_ALC_CFG_4 configuration
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180403203019.8988-1-lorenzo.bianconi@redhat.com>
References: <20180403203019.8988-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180424173202.6011B60131@smtp.codeaurora.org> (sfid-20180424_193208_387249_4CD0AC47)
Date: Tue, 24 Apr 2018 17:32:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Remove unnecessary MT_TX_ALC_CFG_4 configuration since the register value
> will be properly set according to the usage of an external power amplifier
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

cf7b411dcea8 mt76x2: remove unnecessary MT_TX_ALC_CFG_4 configuration

-- 
https://patchwork.kernel.org/patch/10321735/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
