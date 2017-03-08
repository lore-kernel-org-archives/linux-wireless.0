Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbdCHPH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 10:07:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 01/10] rt2x00: rt2800lib: move rt2800_drv_data declaration into
 rt2800lib.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1487150713-3510-2-git-send-email-sgruszka@redhat.com>
References: <1487150713-3510-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Gabor Juhos <juhosg@openwrt.org>,
        Daniel Golle <daniel@makrotopia.org>
Message-Id: <20170308150704.8FC3F607A5@smtp.codeaurora.org> (sfid-20170308_160814_646898_C5D5FE1D)
Date: Wed,  8 Mar 2017 15:07:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> From: Gabor Juhos <juhosg@openwrt.org>
> 
> The rt2800_drv_data structure contains driver specific
> information. Move the declaration into the rt2800lib.h
> header which is a more logical place for it. Also fix
> the comment style to avoid checkpatch warning.
> 
> The patch contains no functional changes, it is in
> preparation for the next patch.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

10 patches applied to wireless-drivers-next.git, thanks.

96609f366c6f rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
a13d985f26f6 rt2800: identify station based on status WCID
5edb05afebba rt2x00: separte filling tx status from rt2x00lib_txdone
56646adf9cd6 rt2x00: separte clearing entry from rt2x00lib_txdone
a09305d05216 rt2x00: add txdone nomatch function
ec80ad70d778 rt2x00: fixup fill_tx_status for nomatch case
293dff78ee05 rt2x00: use txdone_nomatch on rt2800usb
9d7a7a4d2b02 rt2800: status based rate flags for nomatch case
fb47ada8dc3c rt2800: use TXOP_BACKOFF for probe frames
dd35cc0896fa rt2x00: fix rt2x00debug_dump_frame comment

-- 
https://patchwork.kernel.org/patch/9573627/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
