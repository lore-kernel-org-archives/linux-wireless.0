Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:39630 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab0LBOhB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 09:37:01 -0500
Subject: Re: [PATCH] wl12xx: fix illegal memset if debugfs is not enabled
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: j.de.gram@gmail.com
In-Reply-To: <1291122193-3409-1-git-send-email-luciano.coelho@nokia.com>
References: <1291122193-3409-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 16:37:55 +0200
Message-ID: <1291300675.16140.3.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 15:03 +0200, luciano.coelho@nokia.com wrote:
> From: Luciano Coelho <luciano.coelho@nokia.com>
> 
> If we try to reset the debugfs statistics when debugfs is not configured in
> the kernel, we're memset an illegal pointer, because it has never been
> allocated.  So check whether we have debugfs enabled by looking into the
> wl->rootdir before trying to reset the fw_stats struct.
> 
> Reported-by: Joerie de Gram <j.de.gram@gmail.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---

Applied and pushed to wl12xx.


-- 
Cheers,
Luca.

