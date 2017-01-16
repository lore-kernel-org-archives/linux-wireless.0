Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751074AbdAPKOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 05:14:34 -0500
Date: Mon, 16 Jan 2017 11:12:18 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 10/14] rt2x00: rt2800lib: correctly set HT20/HT40
 filter
Message-ID: <20170116101218.GC6968@redhat.com> (sfid-20170116_111438_154778_E8D9E5B8)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116030820.GA32255@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116030820.GA32255@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 04:08:38AM +0100, Daniel Golle wrote:
> From: Serge Vasilugin <vasilugin@yandex.ru>
> 
> Simple patch to correct HT20/HT40 filter setting.
> Tested with Rt3290, Rt3352 and Rt5350
> 
> Signed-off-by: Serge Vasilugin <vasilugin@yandex.ru>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
