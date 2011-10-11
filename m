Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:48035 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754234Ab1JKOna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 10:43:30 -0400
Received: by mail-bw0-f45.google.com with SMTP id zv15so9901303bkb.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 07:43:23 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
From: Luciano Coelho <coelho@ti.com>
To: Shahar Lev <shahar@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318004245-18347-1-git-send-email-shahar@wizery.com>
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 17:43:13 +0300
Message-ID: <1318344193.9690.528.camel@cumari> (sfid-20111011_164336_895301_1D32A51D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 18:17 +0200, Shahar Lev wrote: 
> mac80211 sets the carrier on an IBSS interface even when no network is
> joined. Ignore garbage frames transmitted on a disconnected IBSS
> interface without printing warnings.
> 
> Signed-off-by: Shahar Lev <shahar@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

