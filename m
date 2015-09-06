Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54094 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbIFNYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2015 09:24:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lin <dlin@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>,
	Chor Teck Law <ctlaw@marvell.com>
Subject: Re: [PATCH] Add new mac80211 driver mwlwifi.
References: <6d9f23a4a8bf4315b0c7630a9a1c37ad@SC-EXCH02.marvell.com>
	<1433598191.2467.65.camel@sipsolutions.net>
Date: Sun, 06 Sep 2015 16:24:45 +0300
In-Reply-To: <1433598191.2467.65.camel@sipsolutions.net> (Johannes Berg's
	message of "Sat, 06 Jun 2015 15:43:11 +0200")
Message-ID: <877fo3he8y.fsf@kamboji.qca.qualcomm.com> (sfid-20150906_152515_101686_3394FB23)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2015-06-04 at 04:57 +0000, David Lin wrote:
>
>>  drivers/net/wireless/mwlwifi/Kconfig        |   17 +
>
> Does this driver has any relation to mwifiex? Perhaps the same
> maintainer team, etc.? Could consider moving all the Marvell drivers
> into one directory, but not really necessary I guess.

Actually I would want to start adding vendor directories for wireless
drivers, just like drivers/net/ethernet has, to cleanup the directory
structure. So for example this driver we would have
drivers/net/wireless/marvell/mwlwifi and later we would start moving
existing drivers to vendor drivers as well. Thoughts?

-- 
Kalle Valo
