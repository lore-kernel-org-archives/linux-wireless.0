Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752732AbdLDPPM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 10:15:12 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Li Jin <li.jin@broadcom.com>
Cc: Wright Feng <wright.feng@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, Jason Uy <jason.uy@broadcom.com>
Subject: Re: [PATCH INTERNAL V2 1/1] brcmfmac: add console log support with configurable read size
References: <1511313990-19334-1-git-send-email-li.jin@broadcom.com>
Date: Mon, 04 Dec 2017 17:15:07 +0200
In-Reply-To: <1511313990-19334-1-git-send-email-li.jin@broadcom.com> (Li Jin's
        message of "Tue, 21 Nov 2017 17:26:30 -0800")
Message-ID: <87o9nejzic.fsf@purkki.adurom.net> (sfid-20171204_161530_546800_939F0376)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Li Jin <li.jin@broadcom.com> writes:

> From: Jason Uy <jason.uy@broadcom.com>
>
> Add support for configurable read size so that older wifi
> chips that have size restrictions can be supported.
>
> Signed-off-by: Jason Uy <jason.uy@broadcom.com>
> Reviewed-by: Ray Jui <ray.jui@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> Signed-off-by: Li Jin <li.jin@broadcom.com>

Arend, am I supposed to apply this even if there's this "INTERNAL" tag
in the Subject?

-- 
Kalle Valo
