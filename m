Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38382 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdAaH2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:28:22 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rt2800: enable rt3290 unconditionally on pci probe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1485774767-6655-1-git-send-email-sgruszka@redhat.com>
References: <1485774767-6655-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Message-Id: <20170131072822.026416085F@smtp.codeaurora.org> (sfid-20170131_082825_849785_23D245EF)
Date: Tue, 31 Jan 2017 07:28:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> When we restart system using sysrq RT3290 device do not initalize
> properly, hance always enable it via WLAN_FUN_CTRL register on
> probe.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=85461
> Reported-and-tested-by: Giedrius Statkevičius <edrius.statkevicius@gmail.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

6715208d0a95 rt2800: enable rt3290 unconditionally on pci probe

-- 
https://patchwork.kernel.org/patch/9544879/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
