Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:52422 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035Ab1CCPml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:42:41 -0500
Received: by mail-wy0-f177.google.com with SMTP id 23so1219549wyf.36
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 07:42:40 -0800 (PST)
Subject: Re: [PATCH] wl12xx: Remove private headers in wl1271_tx_reset
From: Luciano Coelho <coelho@ti.com>
To: Ido Yariv <ido@wizery.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>
In-Reply-To: <1298844973-11949-1-git-send-email-ido@wizery.com>
References: <1298844973-11949-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 17:42:43 +0200
Message-ID: <1299166963.7039.5.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 00:16 +0200, Ido Yariv wrote:
> Frames in the tx_frames array include extra private headers, which must
> be removed before passing the skbs to ieee80211_tx_status.
> 
> Fix this by removing any private headers in wl1271_tx_reset, similar to
> how this is done in wl1271_tx_complete_packet.
> 
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied to wl12xx.

-- 
Cheers,
Luca.

