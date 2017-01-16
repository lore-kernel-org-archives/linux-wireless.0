Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44160 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750991AbdAPKQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 05:16:32 -0500
Date: Mon, 16 Jan 2017 11:14:17 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v2 12/14] rt2x00: rt2800lib: support for for RT3352 with
 external PA
Message-ID: <20170116101417.GE6968@redhat.com> (sfid-20170116_111635_702379_6BEAE1AB)
References: <874m114lwq.fsf@codeaurora.org>
 <20170116031444.GA32304@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170116031444.GA32304@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2017 at 04:14:57AM +0100, Daniel Golle wrote:
> This is needed for WiFi to work e.g. on DIR-615 rev.H1 which got
> external RF power amplifiers connected to the WiSoC.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
