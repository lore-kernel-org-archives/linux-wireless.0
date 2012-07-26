Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57064 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab2GZNgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 09:36:23 -0400
Message-ID: <501147D3.2080606@net.t-labs.tu-berlin.de> (sfid-20120726_153642_010106_44F39FFF)
Date: Thu, 26 Jul 2012 15:36:19 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luciano Coelho <coelho@ti.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	ath5k-devel@venema.h4ckr.net, ilw@linux.intel.com,
	users@rt2x00.serialmonkey.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, chunkeey@googlemail.com,
	buytenh@wantstofly.org, dsd@gentoo.org, nbd@openwrt.org
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct ieee80211_tx_info
 and restructure tx-path
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>   (sfid-20120724_221843_511093_701FFAF2) <1343208990.4463.25.camel@jlt3.sipsolutions.net>   (sfid-20120725_113644_599580_8AC4476F) <1343220625.4463.31.camel@jlt3.sipsolutions.net>   <500FEDDD.206@net.t-labs.tu-berlin.de>   <1343244302.3750.44.camel@cumari.coelho.fi>  <1343283856.4611.1.camel@jlt3.sipsolutions.net>  <50110D8C.3010705@net.t-labs.tu-berlin.de> <1343303858.4477.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343303858.4477.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Johannes Berg schrieb:
> On Thu, 2012-07-26 at 11:27 +0200, Thomas Huehn wrote:
>
>> (2)
>> url =
git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
>>
>> last commit e4cbd6542efdab97ed6d38e706b7cac51c68ced7
>
> I'm on this commit + your patch.
>
>   CC [M]  drivers/net/wireless/ti/wlcore/main.o
> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/main.c: In
function ‘wl1271_op_tx’:
>
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/main.c:1202:39:
error: ‘sta’ undeclared (first use in this function)
>
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/main.c:1202:39:
note: each undeclared identifier is reported only once for each function
it appears in
>
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/main.c:1202:2: error:
too many arguments to function ‘wl12xx_tx_get_hlid’
> In file included from
/home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/main.c:43:0:
> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.h:248:4:
note: declared here
>

In my build env I missed the wl12xx tick under the TI submenu ... I will
fix that bug and send a v6.

Greetings Thomas
