Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57810 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752270AbdASM4N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:56:13 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2800: remove warning on bcn_num != rt2x00dev->intf_beaconing
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1484319307-10821-1-git-send-email-sgruszka@redhat.com>
References: <1484319307-10821-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>
Message-Id: <20170119124848.213A760912@smtp.codeaurora.org> (sfid-20170119_135617_829902_FC418900)
Date: Thu, 19 Jan 2017 12:48:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Since rt2800pci update beacon settings asynchronously from
> tbtt tasklet, without beacon_skb_mutex protection, number of
> currently active beacons entries can be different than
> number pointed by rt2x00dev->intf_beaconing. Remove warning
> about that inconsistency.
> 
> Reported-by: evaxige@qq.com
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

feecb0cb466b rt2800: remove warning on bcn_num != rt2x00dev->intf_beaconing

-- 
https://patchwork.kernel.org/patch/9515787/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
