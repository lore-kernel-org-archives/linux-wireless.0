Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46684 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753200AbcKPODT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 09:03:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wefe@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, pieterpg@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Chi-Hsien Lin <chln@cypress.com>,
        wright.feng@cypress.com
Subject: Re: [PATCH] brcmfmac: update beacon IE when bss up and clear when stopped
References: <20161115022322.GA5611@cypress.com>
Date: Wed, 16 Nov 2016 16:03:13 +0200
In-Reply-To: <20161115022322.GA5611@cypress.com> (Wright Feng's message of
        "Tue, 15 Nov 2016 10:23:22 +0800")
Message-ID: <87a8czo732.fsf@kamboji.qca.qualcomm.com> (sfid-20161116_150323_733395_28F06F6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wefe@cypress.com> writes:

> Firmware doesn't update beacon vendor IEs when bss is down, so move brcmf_config_ap_mgmt_ie after BSS up. And host driver should clear IEs when AP stopped so that the IEs in host side will be synced with in firmware side.
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Please word wrap the commit log, see Documentation/SubmittingPatches for
more info.

-- 
Kalle Valo
