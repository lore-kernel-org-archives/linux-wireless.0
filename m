Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943851AbdDTLA4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 07:00:56 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rt2800: fix mt7620 vco calibration registers
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170418093229.GA6026@makrotopia.org>
References: <20170418093229.GA6026@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Tom Psyborg <pozega.tomislav@gmail.com>
Message-Id: <20170420110050.0A8796114D@smtp.codeaurora.org> (sfid-20170420_130103_426927_7A38F6A2)
Date: Thu, 20 Apr 2017 11:00:49 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
> From: Tomislav Požega <pozega.tomislav@gmail.com>
> 
> Use register values from init LNA function instead of the ones from
> restore LNA function. Apply register values based on rx path
> configuration.
> 
> Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Patch applied to wireless-drivers-next.git, thanks.

4bd96b5d3379 rt2800: fix mt7620 vco calibration registers

-- 
https://patchwork.kernel.org/patch/9685229/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
