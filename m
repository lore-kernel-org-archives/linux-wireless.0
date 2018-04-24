Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34640 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbeDXRcz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:32:55 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: set default values in TX_ALC_CFG_{1,
 2} for tempetaure compensation
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <cca4a0d4fbe58e6ecf0f05b953b2df11e30e75b1.1522830473.git.lorenzo.bianconi@redhat.com>
References: <cca4a0d4fbe58e6ecf0f05b953b2df11e30e75b1.1522830473.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180424173255.5517060F5F@smtp.codeaurora.org> (sfid-20180424_193300_544467_E590579E)
Date: Tue, 24 Apr 2018 17:32:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Initialize default values for temperature compensation in TX_ALC_CFG_{1,2}
> if tssi has been enabled
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

b9e5d4feb4fc mt76x2: set default values in TX_ALC_CFG_{1, 2} for tempetaure compensation

-- 
https://patchwork.kernel.org/patch/10322225/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
