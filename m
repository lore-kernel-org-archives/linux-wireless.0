Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:56959 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab1IWLxW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:53:22 -0400
Received: by mail-bw0-f41.google.com with SMTP id zs2so3561220bkb.28
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:53:21 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: implement set_bitrate_mask callback
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316429502-2560-1-git-send-email-eliad@wizery.com>
References: <1316429502-2560-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:53:18 +0300
Message-ID: <1316778798.2157.735.camel@cumari> (sfid-20110923_135325_814036_1D4207D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-19 at 13:51 +0300, Eliad Peller wrote: 
> Save the configured bitrate, and use the min allowed rate
> as the basic rate (e.g. when scanning).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Rebased and applied.  Thank you!

-- 
Cheers,
Luca.

