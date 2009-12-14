Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:63449 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932458AbZLNTTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 14:19:22 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 11:19:22 -0800
Date: Mon, 14 Dec 2009 11:19:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Nick Lee - Unex <nick.lee@unex.com.tw>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 5 MHz and 10 MHz channel bandwidth available on
 any Atheros agn-Card?
Message-ID: <20091214191919.GR5314@tux>
References: <ONEOLGGJJBMDJCOONHKBMECBIOAA.nick.lee@unex.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <ONEOLGGJJBMDJCOONHKBMECBIOAA.nick.lee@unex.com.tw>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2009 at 12:06:53AM -0800, Nick Lee - Unex wrote:
> <--some incoherent deductions-->
> no AR9xxx wifi card can support 10MHz bandwidth now.

Let me clarify on your inaccurate deliberations. Harware-wise AR5416 can support
5 / 10 MHz channels, but this is not supported through software. The newer
family of chipsets AR9280, AR2985, AR9287 all do not support 5 / 10 MHz channels
either in harware or software. So it is fair to say ath9k will not support
5 MHz / 10 MHz channels.

  Luis
