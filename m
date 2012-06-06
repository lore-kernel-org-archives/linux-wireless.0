Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:46726 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754947Ab2FFITs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:19:48 -0400
Received: by laai10 with SMTP id i10so5624360laa.13
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 01:19:45 -0700 (PDT)
Message-ID: <1338970783.7078.5.camel@cumari.coelho.fi> (sfid-20120606_101954_705558_F55B04EC)
Subject: Re: [PATCH] wl18xx: fix fm_coex parameters configuration
From: Luciano Coelho <coelho@ti.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 11:19:43 +0300
In-Reply-To: <1337091340-24800-1-git-send-email-victorg@ti.com>
References: <1337091340-24800-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-15 at 17:15 +0300, Victor Goldenshtein wrote:
> Wrong fm_coex parameters were set during wl18xx
> init phase, fix it.
> 
> Signed-off-by: Ziv Riesel <zivriesel@ti.com>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---

Applied and pushed.

--
Luca.

