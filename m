Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab3CYKhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 06:37:48 -0400
Message-ID: <1364207798.23210.16.camel@cumari.coelho.fi> (sfid-20130325_113753_307731_882A13F4)
Subject: Re: [PATCH] wlcore: use print_hex_dump_debug()
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <arik@wizery.com>
Date: Mon, 25 Mar 2013 12:36:38 +0200
In-Reply-To: <1363100641-24815-1-git-send-email-coelho@ti.com>
References: <1363100641-24815-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-12 at 17:04 +0200, Luciano Coelho wrote:
> We were printing out all the hex dumps regardless of whether dynamic
> debugging was enabled or not.  Now that print_hex_dump_debug() has
> been implemented, we can use that instead.
> 
> Reported-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Luca.

