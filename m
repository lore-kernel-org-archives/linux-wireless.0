Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39644 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753535Ab1INKGS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 06:06:18 -0400
Received: by mail-bw0-f47.google.com with SMTP id 11so1799481bke.34
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 03:06:17 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: support p2p interfaces
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314534181-27200-1-git-send-email-eliad@wizery.com>
References: <1314534181-27200-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 13:06:13 +0300
Message-ID: <1315994773.2498.91.camel@cumari> (sfid-20110914_120621_025579_F91036D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-08-28 at 15:23 +0300, Eliad Peller wrote: 
> Declare support for p2p interfaces, and create p2p_cli/p2p_go
> roles when being asked for.
> 
> Indicate we are using a p2p interface by setting the wl->p2p flag.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied with auto-merge.  Thanks!

-- 
Cheers,
Luca.

