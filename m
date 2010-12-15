Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:42626 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab0LONNo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 08:13:44 -0500
Subject: Re: [PATCH] wl12xx: allow runtime changing of debug_level
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292148935-8709-1-git-send-email-eliad@wizery.com>
References: <1292148935-8709-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 15:15:50 +0200
Message-ID: <1292418950.32385.4.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-12-12 at 12:15 +0200, ext Eliad Peller wrote:
> Currently, the debug level is set in compilation time (by the DEBUG_LEVEL
> const). This method has the advantage of compiling only the relevant
> messages, while optimizing out the unused ones.
> 
> In order to allow runtime control over the debug_level, while optimizing
> out messages when debug messages are not needed, we combine some methods:
> 1. use dynamic_debug (pr_debug) rather then printk.
> 2. add debug_level module param in order to set debug level during insmod.
> 3. add debug_level sysfs file in order to allow dynamic control over the
>    debug level.
> 
> Since patches for pr_debug_hex_dump() implementation haven't been applied yet,
> we are still temporarly using print_hex_dump().
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!


-- 
Cheers,
Luca.

