Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:57310 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946152Ab3BHJVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:21:50 -0500
Message-ID: <1360315251.12803.28.camel@cumari.coelho.fi> (sfid-20130208_102523_589955_4FD8FC6A)
Subject: Re: [PATCH] wlcore: fix wrong remote rates when starting STA role
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <eliad@wizery.com>, <arik@wizery.com>
Date: Fri, 8 Feb 2013 11:20:51 +0200
In-Reply-To: <1360241244-15832-1-git-send-email-coelho@ti.com>
References: <1360241244-15832-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 14:47 +0200, Luciano Coelho wrote:
> In wl18xx, we use a new ACX command in order to set the remote
> supported rates, once we know it (ie. after association).  The wl12xx
> firmware doesn't support changing the rates after the STA is started,
> so we need to use all supported rates.
> 
> Commit 530abe19 (wlcore: add ACX_PEER_CAP command) broke that by using
> wlvif->rate_set when starting the STA role.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

--
Luca.

