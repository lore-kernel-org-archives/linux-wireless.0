Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36695 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYKOPBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 10:01:10 -0500
Date: Sat, 15 Nov 2008 09:50:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] add ar9170 driver
Message-ID: <20081115145004.GA31553@tuxdriver.com> (sfid-20081115_160132_650350_4E1867A3)
References: <1226745636.4120.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226745636.4120.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 11:40:36AM +0100, Johannes Berg wrote:
> This patch adds the ar9170 driver for Atheros 802.11n
> USB hardware ("otus"). The driver currently has basic
> functionality, it will always transmit at 1 or 6 MBit
> rates and only supports managed mode.
> 
> TODO:
>  * rate control/tx status!
>  * figure out QoS (does firmware parse QoS control to get AC?)
>  * implement IBSS mode
>  * implement hardware crypto
>  * implement AP mode
>  * implement mesh mode
>  * make LEDs blink
>  * HT
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Do we want such a basic driver?

In general, yes.

-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
