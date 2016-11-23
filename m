Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965034AbcKWPey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 10:34:54 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2] brcmfmac: update beacon IE after bss up and clear when AP
 stopped
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161118015952.GA22142@cypress.com>
References: <20161118015952.GA22142@cypress.com>
To: Wright Feng <wefe@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, pieterpg@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Chi-Hsien Lin <chln@cypress.com>,
        wright.feng@cypress.com
Message-Id: <20161123153453.914816124F@smtp.codeaurora.org> (sfid-20161123_163457_212094_36C44E4B)
Date: Wed, 23 Nov 2016 15:34:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wefe@cypress.com> wrote:
> Firmware doesn't update beacon/Probe Response vendor IEs correctly when
> bss is down, so we move brcmf_config_ap_mgmt_ie after BSS up. And host
> driver should clear IEs when AP stopped so that the IEs in host side will
> be synced with in firmware side.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Patch applied to wireless-drivers-next.git, thanks.

f25ba69c638b brcmfmac: update beacon IE after bss up and clear when AP stopped

-- 
https://patchwork.kernel.org/patch/9435643/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
