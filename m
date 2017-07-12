Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38114 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752191AbdGLO37 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 10:29:59 -0400
Received: by mail-it0-f49.google.com with SMTP id k192so14030550ith.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jul 2017 07:29:58 -0700 (PDT)
Date: Wed, 12 Jul 2017 10:29:01 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH for-4.13] brcmfmac: fix regression in
 brcmf_sdio_txpkt_hdalign()
Message-ID: <20170712142901.evso24vh3jfj6umk@localhost> (sfid-20170712_163002_717256_D2FC3EA1)
References: <1499851968-18768-1-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1499851968-18768-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 12, 2017 at 10:32:48AM +0100, Arend van Spriel wrote:
> Recent change in brcmf_sdio_txpkt_hdalign() changed the
> behavior and now always returns 0. This resulted in a
> regression which basically renders the device useless.

Should this go via netdev as well, or just wait for Kalle (returning
on Sunday)?

-- 
Bob Copeland %% https://bobcopeland.com/
