Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38546 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935017AbcKQG3S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 01:29:18 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 04/10] rt2800: do not overwrite WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
        <1478095865-8651-5-git-send-email-sgruszka@redhat.com>
        <20161116115319.GA26475@redhat.com>
Date: Thu, 17 Nov 2016 08:29:14 +0200
In-Reply-To: <20161116115319.GA26475@redhat.com> (Stanislaw Gruszka's message
        of "Wed, 16 Nov 2016 12:53:20 +0100")
Message-ID: <87mvgypqkl.fsf@purkki.adurom.net> (sfid-20161117_072923_276754_93AA5FE9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> We already initlized WPDMA_GLO_CFG_WP_DMA_BURST_SIZE to 3 on
> rt2800_init_registers() for USB devices. For PCI devices we will use
> HW default setting, which is 2, so patch does not change behaviour
> on PCI devices.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> v1 -> v2 Changelog fixes

Please resend the whole patchset. For me cherry picking patches
individually like this is difficult and especially error prone.

-- 
Kalle Valo
