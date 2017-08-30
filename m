Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43348 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751333AbdH3Qub (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 12:50:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rt2800: fix TX_PIN_CFG setting for non MT7620 chips
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170825150414.GA9283@redhat.com>
References: <20170825150414.GA9283@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>
Message-Id: <20170830165031.50AAF6077A@smtp.codeaurora.org> (sfid-20170830_185034_806258_8A8B56FF)
Date: Wed, 30 Aug 2017 16:50:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> Since commit 41977e86c984 ("rt2x00: add support for MT7620") we do not
> initialize TX_PIN_CFG setting. This cause breakage at least on some
> RT3573 devices. To fix the problem patch restores previous behaviour
> for non MT7620 chips.
> 
> Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1480829
> Reported-and-tested-by: Jussi Eloranta <jussi.eloranta@csun.edu>
> Cc: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Daniel Golle <daniel@makrotopia.org>

Patch applied to wireless-drivers-next.git, thanks.

83ec48919389 rt2800: fix TX_PIN_CFG setting for non MT7620 chips

-- 
https://patchwork.kernel.org/patch/9922285/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
