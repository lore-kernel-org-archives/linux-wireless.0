Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:50060 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab2HLHbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 03:31:25 -0400
Received: by obbup19 with SMTP id up19so5531762obb.12
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2012 00:31:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120810162532.GA17559@redhat.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	<1344426823-1795-2-git-send-email-victorg@ti.com>
	<20120809115109.GB3516@redhat.com>
	<CAK80WHYjhBbE5Y2Q_-QhbNmxu76BMRCa9=vFyMXwQJQqsGiPUQ@mail.gmail.com>
	<20120810162532.GA17559@redhat.com>
Date: Sun, 12 Aug 2012 10:31:24 +0300
Message-ID: <CAK80WHaN01uGhzj=_mk3C6zNYhaAiQbESxDF6MOKZWdPNb6qDQ@mail.gmail.com> (sfid-20120812_093203_590155_7B2F95D6)
Subject: Re: [PATCH v3 1/7] nl80211/cfg80211: add radar detection command/event
From: "Goldenshtein, Victor" <victorg@ti.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Also what about pure, non HT, channels?
>

Can't think on any reason why we can't support the non HT channels,
the whole point here is the bandwidth.
So, will add them too.

-- 
Thanks,
Victor.
