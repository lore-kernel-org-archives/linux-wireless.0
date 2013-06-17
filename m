Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41155 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab3FQJEi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 05:04:38 -0400
Message-ID: <1371459876.3028.3.camel@cumari.coelho.fi> (sfid-20130617_110441_771889_99C02EB3)
Subject: Re: [PATCH v2] wl18xx: use locally administered MAC address if not
 available from fuse
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <arik@wizery.com>, <eliad@wizery.com>
Date: Mon, 17 Jun 2013 12:04:36 +0300
In-Reply-To: <1368006896-24468-1-git-send-email-coelho@ti.com>
References: <1368006896-24468-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-08 at 12:54 +0300, Luciano Coelho wrote:
> In some R&D chips, the device may be left untrimmed and with the MAC
> address missing from fuse ROM.  In order to support those devices,
> apply a random locally administered MAC address instead.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
> 
> In v2:
> 
> * use eth_random_addr() to generate the locally assigned address,
>   instead of hardcoding it. (thanks Johannes)

Applied.

--
Luca.

