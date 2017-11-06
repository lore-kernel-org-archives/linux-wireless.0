Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbdKFJm1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 04:42:27 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Simon Shields <simon@lineageos.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
References: <20171104132421.GA1541@archbox.home>
Date: Mon, 06 Nov 2017 11:42:21 +0200
In-Reply-To: <20171104132421.GA1541@archbox.home> (Simon Shields's message of
        "Sun, 5 Nov 2017 00:24:28 +1100")
Message-ID: <87efpbrbeq.fsf@purkki.adurom.net> (sfid-20171106_104232_847572_95671403)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Shields <simon@lineageos.org> writes:

> Some boards use an external 32khz clock for low-power
> mode timing. Make sure the clock is powered on while the chipset
> is active.
>
> Signed-off-by: Simon Shields <simon@lineageos.org>
> ---
>  .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt     |  2 ++

For bindings changes I need an ack from device tree maintainers, so
please CC the device tree list.

-- 
Kalle Valo
