Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48288 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdDMONA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 10:13:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3] rt2x00: reverse external PA capability flag logic
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170410132940.GA3308@makrotopia.org>
References: <20170410132940.GA3308@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20170413141259.D5C9460807@smtp.codeaurora.org> (sfid-20170413_161336_689980_E79E01A4)
Date: Thu, 13 Apr 2017 14:12:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
> Consequently refer to external PA instead of inverting the logic and
> use an internal PA capability flag which is a bit confusing.
> Currently this is used for Rt3352 only, but MT7620A also allows for an
> external PA which will be supported by a follow up patch.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

1f242a3de702 rt2x00: reverse external PA capability flag logic

-- 
https://patchwork.kernel.org/patch/9672665/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
