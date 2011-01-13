Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:39670 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932999Ab1AMLdp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 06:33:45 -0500
Subject: Re: [PATCH] wl12xx: change debug_level module param sysfs
 permissions
From: Luciano Coelho <coelho@ti.com>
To: Guy Eilam <guy@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294824809-8364-1-git-send-email-guy@wizery.com>
References: <1294824809-8364-1-git-send-email-guy@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 13:34:04 +0200
Message-ID: <1294918444.2064.22.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 10:33 +0100, Guy Eilam wrote:
> changed the visibility of the debug_level module parameter
> in the filesystem to be readable and writable to the root user.
> It is now accessible under /sys/module/wl12xx/parameters
> 
> removed the debug_level debugfs file that was created under
> /sys/kernel/debug/...
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---

Applied and pushed, thanks!

-- 
Cheers,
Luca.

