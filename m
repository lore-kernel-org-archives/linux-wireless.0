Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944515AbdDTLBT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 07:01:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2800: fix mt7620 E2 channel registers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170418095202.GA7086@makrotopia.org>
References: <20170418095202.GA7086@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Tom Psyborg <pozega.tomislav@gmail.com>
Message-Id: <20170420110113.C67966114D@smtp.codeaurora.org> (sfid-20170420_130123_064905_3C6E2DAC)
Date: Thu, 20 Apr 2017 11:01:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
> From: Tomislav Požega <pozega.tomislav@gmail.com>
> 
> update RF register 47 and 54 values according to vendor driver
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Patch applied to wireless-drivers-next.git, thanks.

a0597834dc0e rt2800: fix mt7620 E2 channel registers

-- 
https://patchwork.kernel.org/patch/9685263/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
