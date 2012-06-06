Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:39726 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab2FFISa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:18:30 -0400
Received: by lboj14 with SMTP id j14so4154668lbo.7
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 01:18:27 -0700 (PDT)
Message-ID: <1338970706.7078.2.camel@cumari.coelho.fi> (sfid-20120606_101835_158259_86189D79)
Subject: Re: [PATCH] wlcore: don't enable BET for high basic rates
From: Luciano Coelho <coelho@ti.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 11:18:26 +0300
In-Reply-To: <1336992947-12927-1-git-send-email-victorg@ti.com>
References: <1336992947-12927-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-14 at 13:55 +0300, Victor Goldenshtein wrote:
> The beacon early termination is not relevant for
> high basic rates, which doesn't contribute
> anything to the PS and only adds unnecessary FW
> work.
> 
> Enable BET only if the basic rate is less than 9
> Mbps.
> 
> Signed-off-by: Ziv Riesel <zivriesel@ti.com>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> Signed-off-by: Igal Chernobelsky <igalc@ti.com>
> ---

Applied and pushed to wl12xx/master.  Thanks!

--
Luca.

