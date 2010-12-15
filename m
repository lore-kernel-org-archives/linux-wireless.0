Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:25322 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab0LONDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 08:03:30 -0500
Subject: Re: [PATCH] wl12xx: add auto-arp support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291887087-3329-1-git-send-email-eliad@wizery.com>
References: <1291887087-3329-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 15:05:35 +0200
Message-ID: <1292418335.32385.2.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 11:31 +0200, ext Eliad Peller wrote:
> The auto-arp feature of wl12xx allows the firmware to automatically
> response to arp requests asking for its ip.
> 
> in order to use it, we configure the arp response template and
> enable the corresponding bit in wl1271_acx_arp_filter (along with
> passing its ip)
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied.  Thanks, ELP! ;)


-- 
Cheers,
Luca.

