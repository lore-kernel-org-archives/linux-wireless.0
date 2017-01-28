Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54414 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750789AbdA1HKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 02:10:14 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4,1/3] rt2x00: add copy of clk for soc devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1484918906-21856-2-git-send-email-sgruszka@redhat.com>
References: <1484918906-21856-2-git-send-email-sgruszka@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Gabor Juhos <juhosg@openwrt.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Mathias Kresin <dev@kresin.me>,
        Michel Stempin <michel.stempin@wanadoo.fr>,
        John Crispin <blogic@openwrt.org>
Message-Id: <20170128070943.8280C60A51@smtp.codeaurora.org> (sfid-20170128_081202_854805_9E1F934F)
Date: Sat, 28 Jan 2017 07:09:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Since clk_get() is not trivial add copy of clk pointer to rt2x00dev
> for System On Chip devices and initialize it on probe routine.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Acked-by: Daniel Golle <daniel@makrotopia.org>

3 patches applied to wireless-drivers-next.git, thanks.

34db70b92fae rt2x00: add copy of clk for soc devices
5c4412e07280 rt2x00: rt2800lib: add support for RT3352 with 20MHz crystal
98e71f44c51d rt2x00: add support for RT5350 WiSoC

-- 
https://patchwork.kernel.org/patch/9528399/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
