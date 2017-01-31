Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdAaH1K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 02:27:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rt2x00: avoid introducing a USB dependency in the rt2x00lib
 module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170127141416.GA6491@redhat.com>
References: <20170127141416.GA6491@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, vishalthanki@gmail.com,
        nbd@nbd.name
Message-Id: <20170131072700.0973B6085F@smtp.codeaurora.org> (sfid-20170131_082724_649673_D6339F53)
Date: Tue, 31 Jan 2017 07:26:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> As reported by Felix:
> 
> Though protected by an ifdef, introducing an usb symbol dependency in
> the rt2x00lib module is a major inconvenience for distributions that
> package kernel modules split into individual packages.
> 
> Get rid of this unnecessary dependency by calling the usb related
> function from a more suitable place.
> 
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Does not apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/ralink/rt2x00/rt2x00dev.c).
error: could not build fake ancestor
Applying: rt2x00: avoid introducing a USB dependency in the rt2x00lib module
Patch failed at 0001 rt2x00: avoid introducing a USB dependency in the rt2x00lib module
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/9541945/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
