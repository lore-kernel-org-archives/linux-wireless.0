Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbdATNYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 08:24:09 -0500
Date: Fri, 20 Jan 2017 14:19:31 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: Re: [PATCH v3] rt2x00: add support for RT5350 WiSoC
Message-ID: <20170120131930.GB21564@redhat.com> (sfid-20170120_142412_858526_DC342422)
References: <20170118144719.GB22837@redhat.com>
 <20170119133834.GA17398@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170119133834.GA17398@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 19, 2017 at 02:38:45PM +0100, Daniel Golle wrote:
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

Patch is mark as from Michel but we have not sign off from Michel,
however after looking on the link we can find out that patch
was originally from Serge, from whom we have sign-off. I'll correct
that.

Stanislaw 
