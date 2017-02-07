Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59840 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753221AbdBGIAV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 03:00:21 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4] rt2x00: avoid introducing a USB dependency in the rt2x00lib
 module
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1486029460-23431-1-git-send-email-sgruszka@redhat.com>
References: <1486029460-23431-1-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Vishal Thanki <vishalthanki@gmail.com>
Message-Id: <20170207080011.00AC660A09@smtp.codeaurora.org> (sfid-20170207_090027_341549_45BD7F07)
Date: Tue,  7 Feb 2017 08:00:10 +0000 (UTC)
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
> Cc: Vishal Thanki <vishalthanki@gmail.com>
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

6232c17438ed rt2x00: avoid introducing a USB dependency in the rt2x00lib module

-- 
https://patchwork.kernel.org/patch/9551537/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
