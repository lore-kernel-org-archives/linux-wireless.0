Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753660AbcL3MIv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 07:08:51 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 01/11] rt2800: make rx ampdu_factor depend on number of rx chains
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
        <1482144777-16760-2-git-send-email-sgruszka@redhat.com>
Date: Fri, 30 Dec 2016 14:08:47 +0200
In-Reply-To: <1482144777-16760-2-git-send-email-sgruszka@redhat.com>
        (Stanislaw Gruszka's message of "Mon, 19 Dec 2016 11:52:47 +0100")
Message-ID: <87r34pk4a8.fsf@purkki.adurom.net> (sfid-20161230_130854_992727_CAAA0603)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> Initalize max ampdu_factor supported by us based on rx chains, vendor
> driver do the same.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

When I was applying these patches I did an off by one error with my
patchwork script ('commit 2-12' vs 'commit 1-11') and accidentally
applied an orinoco patch to wireless-drivers-next along with these
rt2800 patches 1-10. I applied patch 11 separately and everything should
be in wireless-drivers-next now (as soon as I push it). But I would
appreciate if you could double check that everything is ok.

Sorry for the mess.

a08b98196a36 rt2800: make rx ampdu_factor depend on number of rx chains
e49abb19d1bf rt2800: don't set ht parameters for non-aggregated frames
a51b89698ccc rt2800: set minimum MPDU and PSDU lengths to sane values
8f03a7c6e7f9 rt2800: set MAX_PSDU len according to remote STAs capabilities
8845254112ac rt2800: rename adjust_freq_offset function
bc0077053948 rt2800: warn if doing VCO recalibration for unknow RF chip
24d42ef3b152 rt2800: perform VCO recalibration for RF5592 chip
d96324703ffa rt2x00: merge agc and vco works with link tuner
eb79a8fe94c8 rt2800: replace mdelay by usleep on vco calibration.
31369c323ba0 rt2800: replace msleep() with usleep_range() on channel switch

-- 
Kalle Valo
