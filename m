Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40976 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeELIyS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 04:54:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: add a polling delay in mt76x2_mac_stop routine
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <e7c7fcf87f42a137472b8dfd1460a8d41a295bfa.1525960967.git.lorenzo.bianconi@redhat.com>
References: <e7c7fcf87f42a137472b8dfd1460a8d41a295bfa.1525960967.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180512085417.C2E42607E1@smtp.codeaurora.org> (sfid-20180512_105420_995848_0F10BFDC)
Date: Sat, 12 May 2018 08:54:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Add a usleep_range in mt76x2_mac_stop routine in order to add
> a polling delay checking values of MT_MAC_STATUS and IBI_R12 registers
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

6823dc0d91e5 mt76x2: add a polling delay in mt76x2_mac_stop routine

-- 
https://patchwork.kernel.org/patch/10391839/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
