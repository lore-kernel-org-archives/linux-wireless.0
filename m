Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:32910 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610Ab2LKMLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 07:11:08 -0500
Message-ID: <1355227823.3738.131.camel@cumari.coelho.fi> (sfid-20121211_131112_665770_35A1E171)
Subject: Re: [PATCH] wlcore/wl12xx: make sure session id is always zero for
 AP
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>
Date: Tue, 11 Dec 2012 14:10:23 +0200
In-Reply-To: <1354229406-7992-1-git-send-email-arik@wizery.com>
References: <1354229406-7992-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-30 at 00:50 +0200, Arik Nemtsov wrote:
> The 12xx FW doesn't support non-zero session ids for AP-mode. Introduce
> an appropriate quirk to make sure the session id is always zero when
> needed.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> This fixes AP mode for 12xx. I've tested a branch based on
> Luca's git with part1+2+3 applied in addition to this patch.
> Both AP and STA work well on 12xx and 18xx.

Applied, thanks!

--
Luca.

