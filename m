Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:35998 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472Ab1INJT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 05:19:29 -0400
Received: by bkbzu17 with SMTP id zu17so1750231bkb.24
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 02:19:27 -0700 (PDT)
Subject: Re: [PATCH v2 1/5] wl12xx: don't disconnect on recovery
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1314533517-24639-1-git-send-email-eliad@wizery.com>
References: <1314533517-24639-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 12:19:24 +0300
Message-ID: <1315991964.2498.75.camel@cumari> (sfid-20110914_111932_597378_BD3B72C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-08-28 at 15:11 +0300, Eliad Peller wrote: 
> allow full connection recovery by dropping the
> beacon_loss notification.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied the series, thanks!

-- 
Cheers,
Luca.

