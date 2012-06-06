Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:53436 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126Ab2FFISE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:18:04 -0400
Received: by lbbgj10 with SMTP id gj10so4726748lbb.9
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 01:18:01 -0700 (PDT)
Message-ID: <1338970679.7078.1.camel@cumari.coelho.fi> (sfid-20120606_101811_476499_EFFF4972)
Subject: Re: [PATCH v2] wl12xx: fix fm_coex parameters configuration
From: Luciano Coelho <coelho@ti.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Date: Wed, 06 Jun 2012 11:17:59 +0300
In-Reply-To: <1336658913-11396-1-git-send-email-victorg@ti.com>
References: <1336658913-11396-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-10 at 17:08 +0300, Victor Goldenshtein wrote:
> Wrong fm_coex parameters were set during wl12xx
> init phase, fix it.
> 
> Signed-off-by: Ziv Riesel <zivriesel@ti.com>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
> 
> v2: changed the subject wlcore -> wl12xx

Applied and pushed, thanks!

--
Luca.

