Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55386 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbdASMty (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:49:54 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,10/14] rt2x00: rt2800lib: correctly set HT20/HT40 filter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170116030820.GA32255@makrotopia.org>
References: <20170116030820.GA32255@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Message-Id: <20170119124947.9086460960@smtp.codeaurora.org> (sfid-20170119_134958_654074_4FC710D3)
Date: Thu, 19 Jan 2017 12:49:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
> From: Serge Vasilugin <vasilugin@yandex.ru>
> 
> Simple patch to correct HT20/HT40 filter setting.
> Tested with Rt3290, Rt3352 and Rt5350
> 
> Signed-off-by: Serge Vasilugin <vasilugin@yandex.ru>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

3 patches applied to wireless-drivers-next.git, thanks.

e974f3acafe3 rt2x00: rt2800lib: correctly set HT20/HT40 filter
b8c2db58d5a1 rt2x00: rt2800lib: fix rf id for RT3352
dab38e7d251d rt2x00: rt2800lib: support for for RT3352 with external PA

-- 
https://patchwork.kernel.org/patch/9518017/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
