Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53542 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751142AbdHBJcW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 05:32:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 3/3] brcmfmac: fix wrong num_different_channels when mchan feature enabled
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com>
        <1501577287-28904-3-git-send-email-wright.feng@cypress.com>
Date: Wed, 02 Aug 2017 12:32:18 +0300
In-Reply-To: <1501577287-28904-3-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Tue, 1 Aug 2017 16:48:07 +0800")
Message-ID: <87mv7i48nx.fsf@codeaurora.org> (sfid-20170802_113226_130119_7912949B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> The num_different_channels in wiphy info is not correct when firmware
> supports mchan. When mchan is on, num_different_channels is always
> overridden to 1 in brcmf_setup_ifmodes. Correct the logic by moving
> num_different_channels setting forward.
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

Does this fix a user visible bug? If yes, it would be nice to document
that.

-- 
Kalle Valo
