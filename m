Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757700AbcJZOFX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 10:05:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Antonio Quartulli <a@unstable.cc>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        sw@simonwunderlich.de, Antonio Quartulli <antonio@open-mesh.com>
Subject: Re: [NOT FOR MERGE] ath9k: work around key cache corruption
References: <20161018083552.28592-1-a@unstable.cc>
Date: Wed, 26 Oct 2016 17:05:14 +0300
In-Reply-To: <20161018083552.28592-1-a@unstable.cc> (Antonio Quartulli's
        message of "Tue, 18 Oct 2016 16:35:52 +0800")
Message-ID: <87lgxbxl2d.fsf@purkki.adurom.net> (sfid-20161026_160559_960998_C6F835B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <a@unstable.cc> writes:

> From: Antonio Quartulli <antonio@open-mesh.com>
>
> This patch was crafted long time ago to work around a key cache
> corruption problem on ath9k chipsets.
>
> The workaround consists in periodically triggering a worker that
> uploads all the keys to the HW cache. The worker is triggered also
> when the vif detects 21 undecryptable packets.
>
>
> This patch is based on top compat-wireless-2015-10-26.
>
>
> I was asked to release this code to the public and, since it is
> GPL, I am now doing it.

GPL? AFAICS ath9k is under ISC. I'm not sure what you mean with the
sentence above, but it's possible to interpret it so that this patch is
not under ISC license, which is problematic.

-- 
Kalle Valo
