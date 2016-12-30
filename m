Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60248 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753630AbcL3MEC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 07:04:02 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [11/11] rt2x00: add mutex to synchronize config and link tuner
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1482144777-16760-12-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-12-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Message-Id: <20161230120402.2A92B613E9@smtp.codeaurora.org> (sfid-20161230_130405_243773_B6833D46)
Date: Fri, 30 Dec 2016 12:04:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Do not perform mac80211 config and link_tuner at the same time,
> this can possibly result in wrong RF or BBP configuration.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

c7d1c77781f4 rt2x00: add mutex to synchronize config and link tuner

-- 
https://patchwork.kernel.org/patch/9480071/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
