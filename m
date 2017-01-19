Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754230AbdASTIx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 14:08:53 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v3] rt2x00: add support for RT5350 WiSoC
References: <20170118144719.GB22837@redhat.com>
        <20170119133834.GA17398@makrotopia.org>
Date: Thu, 19 Jan 2017 21:08:34 +0200
In-Reply-To: <20170119133834.GA17398@makrotopia.org> (Daniel Golle's message
        of "Thu, 19 Jan 2017 14:38:45 +0100")
Message-ID: <87d1fioojx.fsf@kamboji.qca.qualcomm.com> (sfid-20170119_200917_596291_8CF5BED0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> writes:

> From: Michel Stempin <michel.stempin@wanadoo.fr>
>
> Support for the RT5350 WiSoC was added to OpenWrt after having a
> lengthy debate about the legality of the original submission, see
> https://lists.openwrt.org/pipermail/openwrt-devel/2013-January/018224.html
> MTK/Ralink Acked replied and says we can merge this patch under the GPL.
> https://dev.openwrt.org/changeset/36177
>
> Signed-off-by: Serge Vasilugin <vasilugin@yandex.ru>
> Tested-by: Michel Stempin <michel.stempin@wanadoo.fr>
> Acked-by: John Crispin <blogic@openwrt.org>
> [daniel@makrotopia.org: added commit message, cleaned up code]
>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
> v2: reordered patches to breakout RT3883 from the original series
> v3: remove superflus EEPROM_NIC_CONF0 mangeling from RT5350 patch

As this is not part of the patch series I assume this patch doesn't have
any dependencies and can be applied separately (if Stanislaw acks it).

-- 
Kalle Valo
