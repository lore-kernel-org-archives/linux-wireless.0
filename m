Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdA1Isp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 03:48:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 01/14] rt2x00: rt2800lib: move rt2800_drv_data declaration into
 rt2800lib.h
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170116025444.GA32156@makrotopia.org>
References: <20170116025444.GA32156@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Message-Id: <20170128084836.95F1660A4F@smtp.codeaurora.org> (sfid-20170128_094849_336097_E5806611)
Date: Sat, 28 Jan 2017 08:48:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
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

I didn't quite get what patches (if any) I should take, so I'm dropping
the ones below. Please resend the patches which are ok as a new
pathchset.

9 patches set to Changes Requested.

9517997 [v2,01/14] rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
9518001 [v2,02/14] rt2x00: rt2800lib: introduce RT2800_HAS_HIGH_SHARED_MEM flag
9518003 [v2,03/14] rt2x00: rt2800: serialize shared memory access
9518005 [v2,04/14] rt2x00: rt2800lib: fix beacon generation on RT3593
9518007 [v2,05/14] rt2x00: rt2800lib: add hw_beacon_count field to struct rt2800_drv_data
9518009 [v2,06/14] rt2x00: rt2800lib: init additional beacon offset registers
9518011 [v2,07/14] rt2x00: rt2800lib: fix max supported beacon count for RT3593
9518013 [v2,08/14] rt2x00: rt2800mmio: add a workaround for spurious TX_FIFO_STATUS interrupts
9518015 [v2,09/14] rt2x00: rt2x00pci: set PCI MWI only if supported

-- 
https://patchwork.kernel.org/patch/9517997/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
