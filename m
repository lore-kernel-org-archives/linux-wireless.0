Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45954 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2GZOYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 10:24:02 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5] mac80211: Remove control.sta from struct ieee80211_tx_info and restructure tx-path
References: <1343161108-6941-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	<1343208990.4463.25.camel@jlt3.sipsolutions.net>
	<1343220625.4463.31.camel@jlt3.sipsolutions.net>
	<500FEDDD.206@net.t-labs.tu-berlin.de>
	<1343244302.3750.44.camel@cumari.coelho.fi>
	<1343283856.4611.1.camel@jlt3.sipsolutions.net>
	<50110D8C.3010705@net.t-labs.tu-berlin.de>
	<1343303858.4477.1.camel@jlt3.sipsolutions.net>
	<501147D3.2080606@net.t-labs.tu-berlin.de>
Date: Thu, 26 Jul 2012 17:24:00 +0300
In-Reply-To: <501147D3.2080606@net.t-labs.tu-berlin.de> (Thomas Huehn's
	message of "Thu, 26 Jul 2012 15:36:19 +0200")
Message-ID: <87hasu7g8v.fsf@purkki.adurom.net> (sfid-20120726_162407_186863_0E0299C0)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Huehn <thomas@net.t-labs.tu-berlin.de> writes:

> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/main.c:43:0:
>> /home/johannes/sys/wireless/drivers/net/wireless/ti/wlcore/tx.h:248:4:
> note: declared here
>>
>
> In my build env I missed the wl12xx tick under the TI submenu ... I will
> fix that bug and send a v6.

'make allyesconfig' and 'make allmodconfig' are handy to catch problems
like this. Highly recommended when doing not so simple changes, but be
prepared for long compile times.

-- 
Kalle Valo
